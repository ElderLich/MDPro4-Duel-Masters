import tempfile
import unittest
from pathlib import Path
import zipfile
from tools.build_package import add_entry, archive_name, collect_entries, deck_eligibility, read_catalog, ROOT, write_package


class PackageTests(unittest.TestCase):
    def test_traversal_and_case_collisions_rejected(self):
        for name in ("../x", "/x", "C:/x", "a\\b", "a/../b", "a//b"):
            with self.assertRaises(ValueError):
                archive_name(name)
        entries = {}
        add_entry(entries, "script/c1.lua", b"a")
        with self.assertRaises(ValueError):
            add_entry(entries, "SCRIPT/C1.LUA", b"b")

    def test_database_alias_and_script_closure(self):
        self.assertEqual(len(read_catalog(ROOT)), 1021)

    def test_incomplete_starter_is_not_advertised_as_playable(self):
        cards = read_catalog(ROOT)
        original = ROOT / "deck/DM TCG5 Deadly Decay.ydk"
        self.assertIsNone(deck_eligibility(original, cards))
        lines = original.read_text(encoding="utf-8-sig").splitlines()
        first_card = next(i for i, line in enumerate(lines) if line.isdecimal() and line != "24000000")
        del lines[first_card]
        with tempfile.TemporaryDirectory() as directory:
            incomplete = Path(directory) / "incomplete.ydk"
            incomplete.write_text("\n".join(lines), encoding="utf-8")
            self.assertIsNotNone(deck_eligibility(incomplete, cards))
        entries, receipt = collect_entries(ROOT)
        self.assertIn("deck/DM TCG5 Deadly Decay.ydk", entries)
        self.assertGreater(receipt["playable_deck_count"], 0)

    def test_package_is_deterministic_and_has_no_global_overrides(self):
        entries, receipt = collect_entries(ROOT)
        self.assertEqual(receipt["script_count"], 1017)
        self.assertNotIn("script/utility.lua", entries)
        self.assertNotIn("script/constant.lua", entries)
        self.assertNotIn("translation.conf", entries)
        self.assertNotIn("lflist.conf", entries)
        self.assertIn("script/dm/utility.lua", entries)
        self.assertIn("script/dm/constants.lua", entries)
        for database in (ROOT / "expansions").glob("*.cdb"):
            self.assertEqual(entries[database.name], database.read_bytes())
        with tempfile.TemporaryDirectory() as directory:
            first = Path(directory) / "a.ypk"
            second = Path(directory) / "b.ypk"
            self.assertEqual(write_package(entries, first), write_package(dict(reversed(list(entries.items()))), second))
            with zipfile.ZipFile(first) as archive:
                self.assertIsNone(archive.testzip())
                self.assertEqual(archive.read("script/c24000000.lua"), entries["script/c24000000.lua"])


if __name__ == "__main__":
    unittest.main()
