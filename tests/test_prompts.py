"""Prompt IDs must satisfy the actual MDPro4 description wire contract."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


class PromptTests(unittest.TestCase):
    def test_all_literal_dm_prompts_have_reserved_system_descriptions(self):
        constants = (ROOT / "expansions/constant_dmtcg.lua").read_text(encoding="utf-8")
        rows = re.findall(r"^(DM_(?:DESC|DECKERROR|Q?HINTMSG)_\w+)\s*=\s*(\d+)\b", constants, re.M)
        self.assertEqual(len(rows), 50)
        conf = (ROOT / "expansions/mdpro4-dm-strings.conf").read_text(encoding="utf-8")
        descriptions = {int(key): text for key, text in re.findall(r"^!system (\d+) (.+)$", conf, re.M)}
        self.assertEqual(len(descriptions), 50)
        for name, value in rows:
            key = int(value)
            self.assertTrue(8000 <= key < 10000, name)
            self.assertIn(key, descriptions, name)
        self.assertEqual(descriptions[8504], "Choose a card to put into the mana zone.")
        self.assertEqual(descriptions[8703], "Put a card into your mana zone?")
        self.assertEqual(descriptions[8603], "Choose a shield to break.")

    def test_victory_reasons_remain_byte_sized_and_do_not_replace_ygo_results(self):
        conf = (ROOT / "expansions/mdpro4-dm-strings.conf").read_text(encoding="utf-8")
        reasons = [int(key, 0) for key in re.findall(r"^!victory (\S+) ", conf, re.M)]
        self.assertEqual(reasons, [0x4d, 0x4e, 0x4f])
        self.assertTrue(all(key < 256 for key in reasons))


if __name__ == "__main__":
    unittest.main()
