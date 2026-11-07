from contextlib import closing
import hashlib
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest

from tools.artwork import build_manifest, normalize_name


class ArtworkTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / "expansions").mkdir()
        self.art = self.root / "artwork"
        self.art.mkdir()
        with closing(sqlite3.connect(self.root / "expansions/cards-dm.cdb")) as database:
            database.execute("CREATE TABLE texts(id INTEGER PRIMARY KEY, name TEXT)")
            database.executemany("INSERT INTO texts VALUES (?, ?)",
                                 [(101, "Chilias, the Oracle"), (102, "Aqua Guard"),
                                  (103, "Same Name"), (104, "Same Name")])
            database.commit()

    def image(self, relative, content=b"source bytes"):
        path = self.art / relative
        path.parent.mkdir(exist_ok=True, parents=True)
        path.write_bytes(content)
        return path

    def manifest(self, mapping=None, kind="full_card"):
        return build_manifest(self.root, self.art, mapping, image_kind=kind)

    def test_exact_id_and_unique_normalized_name_only(self):
        self.image("set/101.jpg")
        self.image(" AQUA   guard .jpg")
        self.image("random-uuid.jpg")
        self.image("999.jpg")
        result = self.manifest()
        self.assertEqual([e["card_id"] for e in result["entries"]], [101, 102])
        self.assertEqual(result["entries"][0]["archive_path"], "pics/101.jpg")
        self.assertEqual(result["entries"][0]["sha256"], hashlib.sha256(b"source bytes").hexdigest())
        self.assertEqual(result["missing_card_ids"], [103, 104])
        self.assertEqual(result["totals"]["source_images"], 4)

    def test_ambiguity_is_not_resolved_by_order(self):
        self.image("a/101.jpg")
        self.image("b/101.png")
        self.image("Same Name.jpg")
        result = self.manifest()
        self.assertEqual(result["entries"], [])
        self.assertEqual({e["reason"] for e in result["ambiguous"]},
                         {"multiple_source_images", "duplicate_card_name"})

    def test_reviewed_hash_and_kind_select_an_ambiguous_source(self):
        source = self.image("a/101.png")
        self.image("b/101.jpg")
        mapping = self.root / "map.json"
        mapping.write_text(json.dumps({"schema_version": 1, "entries": [{
            "card_id": 101, "source": "a/101.png", "image_kind": "artwork",
            "sha256": hashlib.sha256(source.read_bytes()).hexdigest()}]}))
        entry = self.manifest(mapping)["entries"][0]
        self.assertEqual((entry["archive_path"], entry["encoding"]), ("art2/101.png", "copy"))
        source.write_bytes(b"modified")
        with self.assertRaisesRegex(ValueError, "changed"):
            self.manifest(mapping)

    def test_scan_conversion_is_explicit_and_artwork_is_not_cropped(self):
        self.image("101.png")
        scan = self.manifest()["entries"][0]
        self.assertEqual((scan["archive_path"], scan["encoding"]), ("pics/101.jpg", "jpeg"))
        art = self.manifest(kind="artwork")["entries"][0]
        self.assertEqual((art["archive_path"], art["encoding"]), ("art2/101.png", "copy"))

    def test_punctuation_is_not_fuzzy_matched(self):
        self.image("Chilias the Oracle.jpg")
        self.assertFalse(self.manifest()["entries"])
        self.assertNotEqual(normalize_name("Chilias, the Oracle"), normalize_name("Chilias the Oracle"))

    def test_reviewed_paths_cannot_escape(self):
        mapping = self.root / "map.json"
        mapping.write_text(json.dumps({"schema_version": 1, "entries": [{
            "card_id": 101, "source": "../101.jpg", "image_kind": "full_card", "sha256": "0" * 64}]}))
        with self.assertRaisesRegex(ValueError, "relative"):
            self.manifest(mapping)

    def test_reviewed_source_is_not_automatically_reused_for_another_card(self):
        source = self.image("101.jpg")
        mapping = self.root / "map.json"
        mapping.write_text(json.dumps({"schema_version": 1, "entries": [{
            "card_id": 102, "source": "101.jpg", "image_kind": "full_card",
            "sha256": hashlib.sha256(source.read_bytes()).hexdigest()}]}))
        result = self.manifest(mapping)
        self.assertEqual([e["card_id"] for e in result["entries"]], [102])

    def test_deterministic_manifest(self):
        self.image("101.jpg")
        self.assertEqual(self.manifest(), self.manifest())


if __name__ == "__main__":
    unittest.main()
