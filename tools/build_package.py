"""Build an explicit, reproducible MDPro4 expansion without global overrides."""
from __future__ import annotations

import argparse
from collections import Counter
from contextlib import closing
import hashlib
import io
import json
import os
from pathlib import Path, PurePosixPath
import re
import sqlite3
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
STAMP = (2000, 1, 1, 0, 0, 0)


def read_version(root: Path) -> str:
    version = (root / "VERSION").read_text(encoding="ascii").strip()
    if not re.fullmatch(r"(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(?:-(?:preview|alpha|beta|rc)\.[1-9][0-9]*)?", version):
        raise ValueError("VERSION must be SemVer, optionally with preview/alpha/beta/rc.N")
    return version

METADATA = "mdpro4-duel-masters"


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def json_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False) + "\n").encode("utf-8")


def read_catalog(root: Path) -> dict[int, dict]:
    cards = {}
    for path in sorted((root / "expansions").glob("*.cdb")):
        with closing(sqlite3.connect(path.resolve().as_uri() + "?mode=ro", uri=True)) as db:
            if db.execute("PRAGMA integrity_check").fetchall() != [("ok",)]:
                raise ValueError(f"Invalid SQLite database: {path}")
            data_ids = {row[0] for row in db.execute("SELECT id FROM datas")}
            text_ids = {row[0] for row in db.execute("SELECT id FROM texts")}
            if data_ids != text_ids:
                raise ValueError(f"Unpaired data/text rows: {path}")
            for code, alias, kind, name in db.execute("SELECT d.id,d.alias,d.type,t.name FROM datas d JOIN texts t ON t.id=d.id"):
                if code in cards:
                    raise ValueError(f"Duplicate card ID {code} in {path}")
                cards[code] = {"name": name, "alias": alias, "type": kind, "database": path.name}
    if not cards:
        raise ValueError("No card databases found")
    for code, card in cards.items():
        if code in range(24000001, 24000005) and card["type"] == 0x4000:
            continue  # Upstream race-list text records, not playable cards.
        if card["alias"] and card["alias"] not in cards:
            raise ValueError(f"Unresolved alias {code} -> {card['alias']}")
        script_code = card["alias"] or code
        if not (root / "expansions/script" / f"c{script_code}.lua").is_file():
            raise ValueError(f"Missing script for {code} (effective ID {script_code})")
    return cards


def check_host_collisions(cards: dict, paths: list[Path]) -> None:
    for path in paths:
        with closing(sqlite3.connect(path.resolve().as_uri() + "?mode=ro", uri=True)) as db:
            overlap = set(cards).intersection(row[0] for row in db.execute("SELECT id FROM datas"))
        if overlap:
            raise ValueError(f"Host card ID collisions in {path}: {sorted(overlap)}")


def archive_name(name: str) -> str:
    path = PurePosixPath(name)
    if "\\" in name or ":" in name or path.is_absolute() or ".." in path.parts or str(path) != name:
        raise ValueError(f"Unsafe archive entry: {name}")
    return name


def add_entry(entries: dict[str, bytes], name: str, data: bytes) -> None:
    name = archive_name(name)
    if name.casefold() in {entry.casefold() for entry in entries}:
        raise ValueError(f"Duplicate archive entry: {name}")
    entries[name] = data


def deck_eligibility(path: Path, cards: dict) -> str | None:
    """Identify ordinary forty-card starters; keep catalogs in source only."""
    zones = {"main": [], "extra": [], "side": []}
    zone = "main"
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        value = line.strip()
        if value in ("#main", "#extra", "!side"):
            zone = value.lstrip("#!")
        elif value and not value.startswith(("#", "!")):
            if not value.isdecimal():
                return "non-numeric card entry"
            zones[zone].append(int(value))
    if zones["extra"] or zones["side"]:
        return "extra or side cards require manual review"
    main = zones["main"]
    if main.count(24000000) != 1 or len(main) != 41:
        return "requires 40 playable cards plus one Rules card"
    if any(code not in cards or code in range(24000001, 24000005) for code in main):
        return "unknown or reference-only card"
    # Paper limits count card names, including printings with different codes.
    if any(count > 4 for count in Counter(cards[code]["name"] for code in main if code != 24000000).values()):
        return "more than four copies of one name; manual exception review required"
    return None


def collect_entries(root: Path, artwork_manifest: dict | None = None) -> tuple[dict, dict]:
    cards = read_catalog(root)
    entries: dict[str, bytes] = {}
    for path in sorted((root / "expansions").glob("*.cdb")):
        add_entry(entries, path.name, path.read_bytes())
    for path in sorted((root / "expansions/script").glob("c[0-9]*.lua")):
        if not re.fullmatch(r"c\d+\.lua", path.name):
            raise ValueError(f"Unexpected script name: {path.name}")
        data = path.read_bytes()
        if b'require "expansions.' in data:
            raise ValueError(f"Legacy filesystem loader remains: {path}")
        add_entry(entries, "script/" + path.name, data)
    for source, target in (("utility_dmtcg.lua", "utility.lua"), ("constant_dmtcg.lua", "constants.lua")):
        add_entry(entries, "script/dm/" + target, (root / "expansions" / source).read_bytes())
    # StringHelper treats >=10000 as packed CDB descriptions. The dedicated
    # expansion uses reviewed sub-10000 IDs, not global YGO label replacements.
    add_entry(entries, "mdpro4-dm-strings.conf", (root / "expansions/mdpro4-dm-strings.conf").read_bytes())
    omitted_decks = []
    for path in sorted((root / "deck").glob("*.ydk")):
        problem = deck_eligibility(path, cards)
        if problem:
            omitted_decks.append({"path": "deck/" + path.name, "reason": problem})
        else:
            add_entry(entries, "deck/" + path.name, path.read_bytes())
    for name in ("LICENSE", "NOTICE.md", "README.md"):
        add_entry(entries, METADATA + "/" + name, (root / name).read_bytes())
    for path in sorted((root / "docs").rglob("*.md")):
        add_entry(entries, METADATA + "/" + path.relative_to(root).as_posix(), path.read_bytes())
    artwork = []
    if artwork_manifest is not None:
        artwork_root = Path(artwork_manifest["artwork_root"]).resolve(strict=True)
        for item in artwork_manifest["entries"]:
            code = item["card_id"]
            if code not in cards:
                raise ValueError(f"Unknown artwork card ID: {code}")
            source = (artwork_root / item["source"]).resolve(strict=True)
            if not source.is_relative_to(artwork_root):
                raise ValueError(f"Artwork escaped root: {source}")
            data = source.read_bytes()
            if digest(data) != item["sha256"]:
                raise ValueError(f"Artwork changed after mapping: {source}")
            target = item["archive_path"]
            if target not in {f"pics/{code}.jpg", f"art/{code}.jpg", f"art2/{code}.png"}:
                raise ValueError(f"Invalid artwork target: {target}")
            # Full-card PNG scans are converted explicitly without cropping.
            if target.endswith(".jpg") and source.suffix.lower() not in {".jpg", ".jpeg"}:
                from PIL import Image
                with Image.open(io.BytesIO(data)) as image:
                    output = io.BytesIO()
                    image.convert("RGB").save(output, format="JPEG", quality=95, subsampling=0)
                    data = output.getvalue()
            add_entry(entries, target, data)
            artwork.append({key: item[key] for key in ("card_id", "source", "sha256", "archive_path", "match")})
    receipt = {
        "schema_version": 1,
        "name": "MDPro4-Duel Masters",
        "version": read_version(root),
        "card_ids": sorted(cards),
        "status": "development-compatibility-package",
        "upstream_commit": "a047df999a2109f52a065fc9760459a0780560b2",
        "card_count": len(cards),
        "script_count": sum(bool(re.fullmatch(r"script/c\d+\.lua", p)) for p in entries),
        "artwork_count": len(artwork),
        "playable_deck_count": sum(name.startswith("deck/") for name in entries),
        "omitted_source_decks": omitted_decks,
        "artwork": artwork,
        "entries": [{"path": name, "size": len(data), "sha256": digest(data)} for name, data in sorted(entries.items())],
    }
    add_entry(entries, METADATA + "/manifest.json", json_bytes(receipt))
    return entries, receipt


def write_package(entries: dict[str, bytes], output: Path, *, immutable: bool = False) -> str:
    output.parent.mkdir(parents=True, exist_ok=True)
    handle, temporary = tempfile.mkstemp(prefix=output.name + ".", suffix=".tmp", dir=output.parent)
    try:
        with os.fdopen(handle, "wb") as stream:
            with zipfile.ZipFile(stream, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
                for name, data in sorted(entries.items()):
                    entry = zipfile.ZipInfo(archive_name(name), date_time=STAMP)
                    entry.compress_type = zipfile.ZIP_DEFLATED
                    entry.create_system = 3
                    entry.external_attr = 0o100644 << 16
                    archive.writestr(entry, data, compresslevel=9)
        with zipfile.ZipFile(temporary) as archive:
            if archive.testzip() is not None:
                raise ValueError("Archive CRC verification failed")
        result = digest(Path(temporary).read_bytes())
        if immutable and output.exists():
            if digest(output.read_bytes()) != result:
                raise ValueError(f"Release payload already exists with different bytes: {output}. Bump VERSION or build a candidate outside Releases.")
        else:
            os.replace(temporary, output)
        return result
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=ROOT)
    parser.add_argument("--output", type=Path, help="Defaults to Releases/v<VERSION>/MDPro4-Duel-Masters-v<VERSION>.ypk")
    parser.add_argument("--artwork-manifest", type=Path)
    parser.add_argument("--host-cdb", type=Path, action="append", default=[])
    args = parser.parse_args()
    version = read_version(args.repo)
    if args.output is None:
        args.output = args.repo / "Releases" / ("v" + version) / ("MDPro4-Duel-Masters-v" + version + ".ypk")
    cards = read_catalog(args.repo)
    check_host_collisions(cards, args.host_cdb)
    artwork = json.loads(args.artwork_manifest.read_text(encoding="utf-8")) if args.artwork_manifest else None
    entries, receipt = collect_entries(args.repo, artwork)
    sha256 = write_package(entries, args.output, immutable=args.output.resolve().is_relative_to((args.repo / "Releases").resolve()))
    args.output.with_suffix(".ypk.sha256").write_text(f"{sha256}  {args.output.name}\n", encoding="ascii")
    print(json.dumps({"output": str(args.output), "sha256": sha256, "entries": len(entries), "cards": receipt["card_count"], "artwork": receipt["artwork_count"]}))


if __name__ == "__main__":
    main()
