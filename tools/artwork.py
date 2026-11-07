"""Inventory supplied artwork without guessing UUID identities or altering images.

The caller must classify the source collection as full_card or artwork. A reviewed
map can override that classification per card. This module never crops an image.
"""
from __future__ import annotations

import argparse
from collections import defaultdict
from contextlib import closing
import hashlib
import json
from pathlib import Path
import sqlite3
import unicodedata

IMAGE_EXTENSIONS = frozenset({".jpg", ".jpeg", ".png", ".webp"})
IMAGE_KINDS = frozenset({"full_card", "artwork"})


def normalize_name(value: str) -> str:
    # Keep punctuation and words: fuzzy matches are never identity evidence.
    return " ".join(unicodedata.normalize("NFKC", value).casefold().split())


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load_cards(repo_root: Path) -> dict[int, str]:
    cards: dict[int, str] = {}
    for database in sorted((Path(repo_root) / "expansions").glob("*.cdb")):
        # This inventory only reads the maintained, quiescent source databases.
        with closing(sqlite3.connect(database.resolve().as_uri() + "?mode=ro", uri=True)) as connection:
            for card_id, name in connection.execute("SELECT id, name FROM texts ORDER BY id"):
                if card_id in cards and cards[card_id] != name:
                    raise ValueError(f"Conflicting names for card {card_id}")
                cards[card_id] = name
    if not cards:
        raise ValueError("No card rows found in expansions/*.cdb")
    return cards


def _safe_source(root: Path, relative: str) -> Path:
    rel = Path(relative)
    if rel.is_absolute() or ".." in rel.parts or "\\" in relative or ":" in relative:
        raise ValueError(f"Artwork map must use a relative forward-slash path: {relative}")
    path = root / rel
    resolved = path.resolve()
    if not resolved.is_relative_to(root):
        raise ValueError(f"Artwork source escapes the source root: {relative}")
    current = path
    while current != root:
        if current.is_symlink() or (hasattr(current, "is_junction") and current.is_junction()):
            raise ValueError(f"Artwork source crosses a link: {relative}")
        current = current.parent
    if not path.is_file() or path.suffix.lower() not in IMAGE_EXTENSIONS:
        raise ValueError(f"Artwork source is not a supported image: {relative}")
    return path


def _archive_path(card_id: int, image_kind: str, suffix: str) -> tuple[str, str]:
    if image_kind not in IMAGE_KINDS:
        raise ValueError(f"Unsupported image kind: {image_kind}")
    if image_kind == "artwork" and suffix == ".png":
        return f"art2/{card_id}.png", "copy"
    folder = "pics" if image_kind == "full_card" else "art"
    return f"{folder}/{card_id}.jpg", "copy" if suffix in {".jpg", ".jpeg"} else "jpeg"


def build_manifest(repo_root: Path, artwork_root: Path, mapping_path: Path | None = None,
                   *, image_kind: str) -> dict:
    """Return deterministic mappings, ambiguity evidence, and source SHA-256s.

    Explicit reviewed maps use {schema_version: 1, entries: [{card_id, source,
    sha256, image_kind}]}. Invalid or changed reviewed inputs fail closed.
    No package mutation occurs here. encoding=jpeg asks the packager for a real
    image conversion; renaming PNG/WebP bytes to .jpg is not sufficient.
    """
    if image_kind not in IMAGE_KINDS:
        raise ValueError("image_kind must be explicitly full_card or artwork")
    root = Path(artwork_root).resolve(strict=True)
    if not root.is_dir():
        raise ValueError("artwork_root must be a directory")
    cards = load_cards(Path(repo_root))
    by_name: dict[str, list[int]] = defaultdict(list)
    for card_id, name in cards.items():
        by_name[normalize_name(name)].append(card_id)
    paths = []
    for path in sorted(root.rglob("*"), key=lambda p: p.relative_to(root).as_posix().casefold()):
        if path.is_file() and path.suffix.lower() in IMAGE_EXTENSIONS:
            relative = path.relative_to(root).as_posix()
            paths.append(_safe_source(root, relative))
    approved = {}
    if mapping_path is not None:
        config = json.loads(Path(mapping_path).read_text(encoding="utf-8"))
        if config.get("schema_version") != 1 or not isinstance(config.get("entries"), list):
            raise ValueError("Unsupported artwork map schema")
        for item in config["entries"]:
            card_id = item["card_id"]
            if type(card_id) is not int or card_id not in cards or card_id in approved:
                raise ValueError(f"Unknown or duplicate mapped card ID: {card_id}")
            source = _safe_source(root, item["source"])
            actual_hash = sha256_file(source)
            if actual_hash != item["sha256"]:
                raise ValueError(f"Reviewed artwork changed: {item['source']}")
            kind = item["image_kind"]
            if kind not in IMAGE_KINDS:
                raise ValueError(f"Invalid reviewed image kind for {card_id}")
            approved[card_id] = (source, "reviewed", kind, actual_hash)
    reviewed_sources = {item[0] for item in approved.values()}
    candidates: dict[int, list[tuple[Path, str]]] = defaultdict(list)
    ambiguous = []
    for path in paths:
        if path in reviewed_sources:
            continue
        if path.stem.isascii() and path.stem.isdecimal():
            card_id = int(path.stem)
            if card_id in cards:
                candidates[card_id].append((path, "exact_id"))
            continue
        ids = by_name.get(normalize_name(path.stem), [])
        if len(ids) == 1:
            candidates[ids[0]].append((path, "exact_name"))
        elif len(ids) > 1:
            ambiguous.append({"source": path.relative_to(root).as_posix(),
                              "card_ids": sorted(ids), "reason": "duplicate_card_name"})
    entries = []
    for card_id in sorted(cards):
        if card_id in approved:
            source, match, kind, digest = approved[card_id]
        else:
            options = candidates.get(card_id, [])
            if not options:
                continue
            if len(options) != 1:
                ambiguous.append({"card_id": card_id,
                                  "sources": [p.relative_to(root).as_posix() for p, _ in options],
                                  "reason": "multiple_source_images"})
                continue
            source, match = options[0]
            kind, digest = image_kind, sha256_file(source)
        archive_path, encoding = _archive_path(card_id, kind, source.suffix.lower())
        entries.append({"card_id": card_id, "card_name": cards[card_id],
                        "source": source.relative_to(root).as_posix(), "sha256": digest,
                        "image_kind": kind, "archive_path": archive_path,
                        "encoding": encoding, "match": match})
    selected_ids = {item["card_id"] for item in entries}
    selected_paths = {item["source"] for item in entries}
    return {"schema_version": 1, "artwork_root": str(root),
            "source_image_kind": image_kind, "entries": entries,
            "missing_card_ids": sorted(cards.keys() - selected_ids),
            "ambiguous": ambiguous,
            "unmatched_sources": [p.relative_to(root).as_posix() for p in paths
                                  if p.relative_to(root).as_posix() not in selected_paths],
            "totals": {"cards": len(cards), "source_images": len(paths),
                       "matched_cards": len(entries), "ambiguous": len(ambiguous)}}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--artwork-root", type=Path, required=True)
    parser.add_argument("--map", type=Path)
    parser.add_argument("--image-kind", choices=sorted(IMAGE_KINDS), required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    manifest = build_manifest(args.repo, args.artwork_root, args.map, image_kind=args.image_kind)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest["totals"], sort_keys=True))


if __name__ == "__main__":
    main()
