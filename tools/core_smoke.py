#!/usr/bin/env python3
"""Load every Duel Masters card using an explicitly supplied MDPro4 native core.

No Editor or live game state is touched. This verifies native script loading and
initial_effect execution, helper lifetime, seeded RNG and opening response flow.
It does not establish complete gameplay or saved-replay acceptance.
The DLL ABI must match MDPro4's create_duel/set_*_reader interface.
"""
from __future__ import annotations

import argparse
import ctypes as ct
import hashlib
import json
from pathlib import Path
import sqlite3
import struct
import sys
import zipfile


class CardData(ct.Structure):
    _fields_ = [("code", ct.c_uint32), ("alias", ct.c_uint32),
                ("setcode", ct.c_uint16 * 16)] + [
        (name, ct.c_uint32) for name in ("type", "level", "attribute", "race")
    ] + [("attack", ct.c_int32), ("defense", ct.c_int32)] + [
        (name, ct.c_uint32) for name in ("lscale", "rscale", "link_marker", "rule_code")
    ]


def sha256(path: Path) -> str:
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


class NativeSmoke:
    def __init__(self, root: Path, core: Path, host_scripts: Path,
                 package: Path | None = None):
        self.root = root
        self.lib = ct.CDLL(str(core.resolve()))
        self.host = zipfile.ZipFile(host_scripts)
        self.package = zipfile.ZipFile(package) if package else None
        self.buffers = {}
        self.logs = []
        self.reads = set()
        self.probe = b""
        self.cards = {}
        for path in sorted((root / "expansions").glob("*.cdb")):
            with sqlite3.connect(path.resolve().as_uri() + "?mode=ro&immutable=1", uri=True) as db:
                for row in db.execute("SELECT id,alias,setcode,type,level,attribute,race,atk,def FROM datas"):
                    if row[0] in self.cards:
                        raise ValueError(f"Duplicate card ID: {row[0]}")
                    self.cards[row[0]] = row
        self.reference_ids = {24000001, 24000002, 24000003, 24000004}
        self.playable = {code: row for code, row in self.cards.items() if code not in self.reference_ids}
        self.initialized = 0
        self._bind()

    def api(self, name, result, *args):
        function = getattr(self.lib, name)
        function.restype = result
        function.argtypes = list(args)
        return function

    def _bind(self):
        ptr, uint, integer = ct.c_void_p, ct.c_uint32, ct.c_int32
        self.create = self.api("create_duel", ptr, uint)
        self.destroy = self.api("end_duel", None, ptr)
        self.add = self.api("new_card", None, ptr, uint, *([ct.c_uint8] * 5))
        self.preload = self.api("preload_script", integer, ptr, ct.c_char_p)
        self.get_log = self.api("get_log_message", None, ptr, ptr)
        self.read_card_callback = ct.CFUNCTYPE(uint, uint, ct.POINTER(CardData))(self.read_card)
        self.read_script_callback = ct.CFUNCTYPE(ptr, ct.c_char_p, ct.POINTER(integer))(self.read_script)
        self.log_callback = ct.CFUNCTYPE(uint, ptr, uint)(self.log)
        self.api("set_card_reader", None, type(self.read_card_callback))(self.read_card_callback)
        self.api("set_script_reader", None, type(self.read_script_callback))(self.read_script_callback)
        self.api("set_message_handler", None, type(self.log_callback))(self.log_callback)

    def read_card(self, code, pointer):
        value = CardData()
        row = self.cards.get(code)
        if row:
            value.code, value.alias = row[:2]
            for index in range(4):
                value.setcode[index] = (row[2] >> (index * 16)) & 0xffff
            value.type = row[3]
            value.level = row[4] & 0xff
            value.lscale = (row[4] >> 24) & 0xff
            value.rscale = (row[4] >> 16) & 0xff
            value.attribute, value.race, value.attack, value.defense = row[5:]
        pointer[0] = value
        return code

    def source_script(self, key):
        if self.package and key in self.package.namelist():
            return self.package.read(key)
        if not self.package:
            helper = {"script/dm/utility.lua": "utility_dmtcg.lua",
                      "script/dm/constants.lua": "constant_dmtcg.lua"}.get(key)
            if helper:
                return (self.root / "expansions" / helper).read_bytes()
            name = key.removeprefix("script/")
            if name.startswith("c") and name[1:-4].isdigit() and name.endswith(".lua"):
                path = self.root / "expansions/script" / name
                if path.is_file():
                    return path.read_bytes()
        return self.host.read(key)

    def read_script(self, name, size):
        key = name.decode("utf-8").replace("\\", "/").removeprefix("./")
        if not key.startswith("script/"):
            key = "script/" + key
        try:
            data = self.probe if key == "script/mdpro4_dm_smoke.lua" else self.source_script(key)
            # Keep every native callback buffer alive through end_duel.
            buffer = ct.create_string_buffer(data)
            self.buffers.setdefault(key, []).append(buffer)
            self.reads.add(key)
            size[0] = len(data)
            return ct.addressof(buffer)
        except (KeyError, OSError) as error:
            size[0] = 0
            self.logs.append({"kind": "missing-script", "script": key, "error": str(error)})
            return None

    def log(self, duel, kind):
        buffer = ct.create_string_buffer(16384)
        self.get_log(duel, buffer)
        self.logs.append({"kind": int(kind), "message": buffer.value.decode("utf-8", errors="replace")})
        return 0

    def run_probe(self, duel, source):
        self.probe = source.encode("utf-8")
        if not self.preload(duel, b"./script/mdpro4_dm_smoke.lua"):
            raise RuntimeError("Native Lua probe failed")

    def card_load(self):
        duel = self.create(24000000)
        if not duel:
            raise RuntimeError("create_duel failed")
        try:
            self.run_probe(duel, """
local original_type=type
assert(type(Duel.LoadScript)=="function", "Duel.LoadScript required")
assert(type(Duel.GetRandomNumber)=="function", "Duel.GetRandomNumber required")
assert(require==nil and debug==nil, "smoke expects sandboxed native core")
Duel.LoadScript("dm/utility.lua")
assert(MDPro4DM and MDPro4DMConstants, "DM helper not initialized")
assert(type==original_type, "DM helper replaced global Lua type")
local original_draw=Duel.Draw
local original_select=Group.Select
local original_dm=MDPro4DM
Duel.LoadScript("dm/utility.lua")
assert(MDPro4DM==original_dm and Duel.Draw==original_draw and Group.Select==original_select,
    "loading helper twice wrapped host functions twice")
""")
            for code in sorted(self.playable):
                self.add(duel, code, 0, 0, 1, 0, 8)
                self.initialized += 1
            self.run_probe(duel, """
local expected={%s}
for _,code in ipairs(expected) do
    local script=_G["c"..code]
    assert(script and script.duel_masters_card, "missing initialized DM script: "..code)
end
""" % ",".join(str(code) for code in sorted({row[1] or code for code, row in self.playable.items()})))
        finally:
            self.destroy(duel)
            self.buffers.clear()

    @staticmethod
    def packets(raw):
        """Parse the bounded startup vocabulary using CoreWrapper.cs byte widths.

        Unknown packets fail the fixture rather than guessing a response boundary.
        """
        offset = 0
        while offset < len(raw):
            begin = offset
            message = raw[offset]
            offset += 1

            def take(count):
                nonlocal offset
                if count < 0 or offset + count > len(raw):
                    raise RuntimeError(f"Truncated native packet {message}")
                first = raw[offset] if count else 0
                offset += count
                return first

            if message in (1, 3, 37, 61, 63, 65, 74, 113, 114):
                pass
            elif message in (2, 18, 19, 24, 38, 165):
                take(6)
            elif message in (5, 41):
                take(2)
            elif message == 11:
                take(1)
                for _ in range(5):
                    take(take(1) * 7)
                take(take(1) * 11 + 3)
            elif message == 12:
                take(13)
            elif message in (13, 91, 92, 94, 100):
                take(5)
            elif message == 14:
                take(1)
                take(take(1) * 4)
            elif message in (15, 20):
                take(4)
                take(take(1) * 8)
            elif message == 16:
                take(1)
                count = take(1)
                take(9 + count * 14)
            elif message in (30, 42):
                take(1)
                take(take(1) * 7)
            elif message == 31:
                take(2)
                take(take(1) * 7)
            elif message in (32, 34, 35, 40, 71, 72, 73, 75, 76):
                take(1)
            elif message in (33, 39, 90):
                take(1)
                take(take(1) * 4)
            elif message in (50, 55, 70):
                take(16)
            elif message == 53:
                take(9)
            elif message in (54, 60, 62, 64, 93, 96, 97):
                take(8)
            elif message == 160:
                take(9)
            else:
                raise RuntimeError(f"Unsupported startup packet {message} at {begin}")
            yield raw[begin:offset]

    def opening(self, starting_hand=0, draw_per_turn=0):
        ptr, integer, uint = ct.c_void_p, ct.c_int32, ct.c_uint32
        player_info = self.api("set_player_info", None, ptr, integer, integer, integer, integer)
        start = self.api("start_duel", None, ptr, uint)
        process = self.api("process", uint, ptr)
        get_message = self.api("get_message", integer, ptr, ptr)
        respond = self.api("set_responsei", None, ptr, integer)
        query = self.api("query_field_card", integer, ptr, ct.c_uint8, ct.c_uint8, uint, ptr, integer)
        count = self.api("query_field_count", integer, ptr, ct.c_uint8, ct.c_uint8)
        duel = self.create(24000000)
        events = []
        answered_charge = False
        empty_chain_passes = 0
        pending = None
        try:
            # Ten distinct creature IDs, four copies each. The rules support card
            # is additional and removed before the 40-card deck validation.
            codes = [24001002, 24001003, 24001004, 24001005, 24001010,
                     24001011, 24001012, 24001013, 24001014, 24001015]
            for player in (0, 1):
                player_info(duel, player, 8000, starting_hand, draw_per_turn)
                self.add(duel, 24000000, player, player, 1, 0, 8)
                for code in codes:
                    for _ in range(4):
                        self.add(duel, code, player, player, 1, 0, 8)
            start(duel, 5 << 16)
            for _ in range(100):
                result = process(duel)
                length = result & 0x0fffffff
                if length:
                    buffer = ct.create_string_buffer(length)
                    actual = get_message(duel, buffer)
                    if actual != length:
                        raise RuntimeError("Core message size changed during fixture")
                    for packet in self.packets(buffer.raw):
                        message = packet[0]
                        events.append(packet)
                        if message in (1, 5):
                            raise RuntimeError(f"Opening unexpectedly ended with packet {message}")
                        if message in (11, 12, 13, 14, 15, 16, 18, 19, 24):
                            if pending is not None:
                                raise RuntimeError("Multiple unconsumed response requests")
                            pending = packet
                if pending:
                    if pending[0] == 15 and not answered_charge and pending[3:5] == bytes((0, 1)):
                        # Decline the optional mana charge, then observe continuation.
                        respond(duel, 0)
                        answered_charge = True
                        pending = None
                    elif pending[0] == 16 and pending[2] == 0 and pending[3] == 0:
                        respond(duel, -1)
                        empty_chain_passes += 1
                        pending = None
                    elif pending[0] == 11:
                        break
                    else:
                        raise RuntimeError(f"Unexpected opening response request {pending[0]}")
            else:
                raise RuntimeError("Opening exceeded bounded process limit")
            if not answered_charge:
                raise RuntimeError("Opening never reached optional mana charge")
            players = []
            for player in (0, 1):
                buffer = ct.create_string_buffer(65536)
                length = query(duel, player, 8, 3, buffer, 0)
                offset = 0
                fields = []
                while offset < length:
                    size = struct.unpack_from("<I", buffer, offset)[0]
                    if size < 4 or offset + size > length:
                        raise RuntimeError("Invalid native query record length")
                    if size > 8:
                        flags, code = struct.unpack_from("<II", buffer, offset + 4)
                        if flags & 3 != 3:
                            raise RuntimeError("Incomplete native card position query")
                        controller, location, sequence, position = struct.unpack_from("4B", buffer, offset + 12)
                        fields.append({"code": code, "sequence": sequence, "position": position})
                    offset += size
                shields = [entry for entry in fields if entry["sequence"] < 5]
                support = [entry for entry in fields if entry["sequence"] == 5]
                state = {"player": player, "deck": count(duel, player, 1),
                         "hand": count(duel, player, 2), "shield_count": len(shields),
                         "all_shields_facedown": all(entry["position"] & 10 for entry in shields),
                         "rule_card_in_field_slot": len(support) == 1 and support[0]["code"] == 24000000}
                if (state["deck"], state["hand"], state["shield_count"]) != (30, 5, 5):
                    raise RuntimeError(f"Unexpected opening state: {state}")
                if not state["all_shields_facedown"] or not state["rule_card_in_field_slot"]:
                    raise RuntimeError(f"Unexpected shield/rule position: {state}")
                players.append(state)
            selection_hints = [packet for packet in events if packet[0] == 2 and packet[1] == 3]
            # Exactly one prompt describes the legitimate optional mana charge.
            shield_hints = sum(struct.unpack_from("<I", packet, 3)[0] in self.cards for packet in selection_hints)
            placement_requests = sum(packet[0] == 18 for packet in events)
            if len(selection_hints) != 1 or shield_hints or placement_requests:
                raise RuntimeError("Opening exposed a shield placement prompt or hint")
            return {"passed": True, "players": players, "shield_identity_hints": shield_hints, "mana_charge_selection_hints": len(selection_hints),
                    "placement_requests": placement_requests, "charge_response_continued_to_idle": True,
                    "message_count": len(events), "empty_chain_passes": empty_chain_passes, "fixture_starting_hand": starting_hand, "fixture_draw_per_turn": draw_per_turn}
        finally:
            self.destroy(duel)
            self.buffers.clear()

    def rng_sequence(self, seed):
        start = len(self.logs)
        duel = self.create(seed)
        try:
            self.run_probe(duel, """
assert(MDPro4DM==nil, "DM helper leaked between duels")
local values={}
for i=1,32 do
    values[i]=Duel.GetRandomNumber(1,1000000)
end
Debug.Message("MDPRO4_DM_RNG:"..table.concat(values,","))
""")
        finally:
            self.destroy(duel)
            self.buffers.clear()
        messages = [entry["message"].split("MDPRO4_DM_RNG:",1)[1]
                    for entry in self.logs[start:]
                    if "MDPRO4_DM_RNG:" in entry.get("message", "")]
        if len(messages) != 1:
            raise RuntimeError("Native RNG probe did not emit exactly one sequence")
        return messages[0]

    def close(self):
        if self.package:
            self.package.close()
        self.host.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--core", type=Path, required=True)
    parser.add_argument("--host-scripts", type=Path, required=True)
    parser.add_argument("--package", type=Path, help="Validate packaged scripts instead of source mappings")
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    smoke = NativeSmoke(args.root, args.core, args.host_scripts, args.package)
    failure = None
    opening = None
    host_opening = None
    rng_equal = False
    rng_different = False
    try:
        smoke.card_load()
        opening = smoke.opening()
        host_opening = smoke.opening(starting_hand=5, draw_per_turn=1)
        first = smoke.rng_sequence(24000000)
        rng_equal = first == smoke.rng_sequence(24000000)
        rng_different = first != smoke.rng_sequence(24000001)
        if not rng_equal or not rng_different:
            raise RuntimeError("Seeded native RNG lifetime check failed")
    except Exception as error:
        failure = str(error)
    finally:
        smoke.close()
    errors = [entry for entry in smoke.logs if "MDPRO4_DM_RNG:" not in entry.get("message", "")]
    report = {"passed": failure is None and not errors, "failure": failure,
              "playable_cards_initialized": smoke.initialized,
              "excluded_reference_ids": sorted(smoke.reference_ids),
              "canonical_card_script_count": len({row[1] or code for code, row in smoke.playable.items()}),
              "card_scripts_read": sum(key.startswith("script/c") and key[8:-4].isdigit() for key in smoke.reads),
              "core_sha256": sha256(args.core), "host_scripts_sha256": sha256(args.host_scripts),
              "package_sha256": sha256(args.package) if args.package else None,
              "opening": opening,
              "host_defaults_opening": host_opening,
              "seed_reproducible": rng_equal, "different_seed_changes_sequence": rng_different,
              "scope": "native loading/initial_effect/helper lifetime/RNG/opening continuation; no full duel or replay acceptance",
              "errors": errors}
    output = json.dumps(report, indent=2, ensure_ascii=False)
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(output + "\n", encoding="utf-8")
    print(output)
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    sys.exit(main())
