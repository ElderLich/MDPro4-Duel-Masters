#!/usr/bin/env python3
"""Complete real native DM games and re-run saved YRP1 response recordings.

Uses ordinary core offers/responses, never injected state or forced winners.
This is deterministic native gameplay/replay evidence, not Unity visual QA or
complete card/rules coverage. The host must separately open these .yrp files.
"""
from pathlib import Path
import sys
sys.dont_write_bytecode = True
from core_smoke import NativeSmoke, ct, sha256
import argparse
import collections
import hashlib
import json
import struct
import time


def core_seed(seed):
    """Match CoreWrapper.BuildYRP3dBuffer's first MersenneTwister output."""
    mt = [seed]
    for i in range(1, 624):
        mt.append(1812433253 * (mt[-1] ^ mt[-1] >> 30) + i & 0xffffffff)
    for i in range(624):
        y = mt[i] & 0x80000000 | mt[(i + 1) % 624] & 0x7fffffff
        mt[i] = mt[(i + 397) % 624] ^ y >> 1 ^ (0x9908b0df if y & 1 else 0)
    y = mt[0]
    y ^= y >> 11
    y ^= y << 7 & 0x9d2c5680
    y ^= y << 15 & 0xefc60000
    y ^= y >> 18
    return y & 0xffffffff


def packets(raw):
    """Read the exercised CoreWrapper.Analyse grammar; reject unknown opcodes.

    SelectChain entries are 14 bytes; ConfirmCards includes skip_panel. The
    older GameAnalyser transport is not the deployed single/replay core ABI.
    """
    p = 0
    while p < len(raw):
        start = p
        m = raw[p]
        p += 1

        def take(n):
            nonlocal p
            if n < 0 or p + n > len(raw):
                raise ValueError(f'Truncated {m} at {start}: {raw.hex()}')
            value = raw[p] if n else 0
            p += n
            return value
        if m in (1, 3, 37, 61, 63, 65, 74, 112, 113, 114):
            pass
        elif m in (2, 18, 19, 24, 38, 140, 141, 165):
            take(6)
        elif m in (5, 41):
            take(2)
        elif m == 10:
            take(1)
            take(take(1) * 11)
            take(take(1) * 8 + 2)
        elif m == 11:
            take(1)
            for _ in range(5):
                take(take(1) * 7)
            take(take(1) * 11 + 3)
        elif m == 12:
            take(13)
        elif m in (13, 91, 92, 94, 100):
            take(5)
        elif m in (14, 142, 143):
            take(1)
            take(take(1) * 4)
        elif m in (15, 20):
            take(4)
            take(take(1) * 8)
        elif m == 16:
            take(1)
            n = take(1)
            take(9 + n * 14)
        elif m in (21, 25, 30, 42):
            take(1)
            take(take(1) * 7)
        elif m == 31:
            take(2)
            take(take(1) * 7)
        elif m in (32, 34, 35, 40, 71, 72, 73, 75, 76):
            take(1)
        elif m in (33, 39, 80, 81, 90):
            take(1)
            take(take(1) * 4)
        elif m == 83:
            take(take(1) * 4)
        elif m in (50, 55, 70):
            take(16)
        elif m == 53:
            take(9)
        elif m == 54:
            take(8)
        elif m == 56:
            take(4)
        elif m in (60, 62, 64, 93, 96, 97, 110, 120):
            take(8)
        elif m == 95:
            take(4)
        elif m in (101, 102):
            take(7)
        elif m == 111:
            take(26)
        elif m in (130, 131):
            take(1)
            take(take(1))
        elif m == 160:
            take(9)
        else:
            raise ValueError(f'Unsupported packet {m} at {start}: {raw[start:start + 40].hex()}')
        yield raw[start:p]

RESPONSES = {10, 11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 24, 25, 140, 141, 142, 143}


class FullDuel(NativeSmoke):
    priority_codes = frozenset()
    decline_triggers = False

    def decide(self, packet):
        m = packet[0]

        def integer(v):
            return struct.pack('<i', v)
        if m == 11:
            pos = 2
            groups = []
            for width in (7, 7, 7, 7, 7, 11):
                n = packet[pos]
                pos += 1
                groups.append([packet[pos + i * width:pos + (i + 1) * width] for i in range(n)])
                pos += n * width
            if groups[1]:
                choices = [
                    (0 if struct.unpack_from('<I', c)[0] in self.priority_codes else 1,
                     self.cards[struct.unpack_from('<I', c)[0]][4], i)
                    for i, c in enumerate(groups[1])
                ]
                return integer(min(choices)[2] << 16 | 1)
            if groups[5]:
                return integer(5)
            if packet[pos]:
                return integer(6)
            if packet[pos + 1]:
                return integer(7)
            raise ValueError('No playable idle action')
        if m == 10:
            pos = 2
            n = packet[pos]
            pos += 1
            if n:
                return integer(0)
            pos += n * 11
            n = packet[pos]
            pos += 1
            if n:
                choices = [
                    (0 if struct.unpack_from('<I', packet, pos + i * 8)[0]
                     in self.priority_codes else 1, i)
                    for i in range(n)
                ]
                return integer(min(choices)[1] << 16 | 1)
            pos += n * 8
            if packet[pos + 1]:
                return integer(3)
            if packet[pos]:
                return integer(2)
            raise ValueError('No battle continuation')
        if m in (12, 13):
            return integer(1)
        if m in (14, 142, 143):
            return integer(0)
        if m in (15, 20):
            minimum, maximum, count = packet[3:6]
            selected = max(minimum, min(1, maximum, count))
            indices = list(range(count))
            # Only prioritize publicly held own hand choices; never select a
            # facedown shield by its code (the fixture sees raw core packets).
            if self.hint == 8504 and count and all((packet[6 + i * 8 + 5] == 2 for i in range(count))):
                indices.sort(
                    key=lambda i: (
                        struct.unpack_from('<I', packet, 6 + i * 8)[0] not in self.priority_codes,
                        self.cards[struct.unpack_from('<I', packet, 6 + i * 8)[0]][4]
                    ),
                    reverse=True
                )
            return bytes([selected, *indices[:selected]])
        if m == 16:
            count = packet[2]
            # Byte3 is spcount. The forced bit is per entry at byte13+14*i.
            forced = any((packet[13 + i * 14] for i in range(count)))
            trigger = any((struct.unpack_from('<I', packet, 22 + i * 14)[0] == 9663 for i in range(count)))
            if self.decline_triggers and trigger and (not forced):
                return integer(-1)
            return integer(0 if count else -1)
        if m in (18, 24):
            player, count = packet[1:3]
            mask = struct.unpack_from('<I', packet, 3)[0]
            choices = [i for i in range(32) if not mask >> i & 1]
            data = []
            for bit in choices[:count or 1]:
                data.extend([player if bit < 16 else 1 - player, 4 if bit % 16 < 8 else 8, bit % 8])
            return bytes(data)
        if m == 19:
            mask = packet[6]
            return integer(next((bit for bit in (1, 4, 2, 8) if mask & bit)))
        if m in (21, 25):
            return bytes(range(packet[2]))
        if m in (140, 141):
            count = packet[2]
            mask = struct.unpack_from('<I', packet, 3)[0]
            choices = [1 << i for i in range(32) if mask >> i & 1]
            return integer(sum(choices[:count]))
        raise ValueError(f'Unsupported choice {m}')

    def game(self, seed, decks, replay_responses=None, failure_path=None):
        ptr, integer, uint = (ct.c_void_p, ct.c_int32, ct.c_uint32)
        setup = self.api('set_player_info', None, ptr, integer, integer, integer, integer)
        start = self.api('start_duel', None, ptr, uint)
        process = self.api('process', uint, ptr)
        messages = self.api('get_message', integer, ptr, ptr)
        response = self.api('set_responseb', None, ptr, ptr)
        duel = self.create(core_seed(seed))
        if not duel:
            raise RuntimeError('create_duel returned null')
        events = []
        replies = []
        self.hint = None
        turns = 0
        result = None
        deadline = time.monotonic() + 45
        try:
            for player, deck in enumerate(decks):
                setup(duel, player, 8000, 5, 1)
                for code in deck:
                    self.add(duel, code, player, player, 1, 0, 8)
            start(duel, 5 << 16)
            for step in range(10000):
                if time.monotonic() > deadline:
                    raise RuntimeError('Native game deadline exceeded')
                status = process(duel)
                length = status & 0xfffffff
                pending = None
                if length:
                    buffer = ct.create_string_buffer(length)
                    if messages(duel, buffer) != length:
                        raise ValueError('Changed native message size')
                    for packet in packets(buffer.raw):
                        events.append(packet)
                        m = packet[0]
                        if m == 1:
                            raise ValueError('Native rejected response: ' + repr(replies[-1:]))
                        if m == 2 and packet[1] == 3:
                            self.hint = struct.unpack_from('<I', packet, 3)[0]
                        if m == 40:
                            turns += 1
                        if m == 5:
                            result = {'winner': packet[1], 'reason': packet[2]}
                        if m in RESPONSES:
                            if pending:
                                raise ValueError('Two pending responses')
                            pending = packet
                if result:
                    break
                if pending:
                    if replay_responses is None:
                        chosen = self.decide(pending)
                    else:
                        if len(replies) >= len(replay_responses):
                            raise ValueError('Replay responses exhausted')
                        chosen = replay_responses[len(replies)]
                    replies.append(chosen)
                    if len(chosen) > 64:
                        raise ValueError('Response exceeds ABI buffer')
                    response(duel, ct.create_string_buffer(chosen, 64))
            else:
                raise RuntimeError('Native game step bound exceeded')
            if not result:
                raise RuntimeError('Game never ended')
            if replay_responses is not None and len(replies) != len(replay_responses):
                raise ValueError('Unused saved replay responses')
            counts = collections.Counter((p[0] for p in events))
            report = {
                'result': result, 'turns': turns, 'packets': len(events),
                'responses': len(replies), 'event_counts': dict(counts),
                'stream_sha256': hashlib.sha256(b''.join(events)).hexdigest()
            }
            return report, events, replies
        except Exception as error:
            if failure_path:
                failure = {
                    'error': str(error), 'turns': turns,
                    'last_events': [p.hex() for p in events[-40:]],
                    'last_responses': [p.hex() for p in replies[-20:]],
                    'logs': self.logs
                }
                failure_path.write_text(json.dumps(failure, indent=2), encoding='utf-8')
            raise
        finally:
            self.destroy(duel)
            self.buffers.clear()


def save_replay(path, seed, decks, responses):
    """Write the host ReplaySelectorUI/YGOSharp uncompressed YRP1 layout.

    Header32 bytes; names20 UTF-16 code units each; settings/deck counts uint32;
    response length uint8. The public seed is pre-MersenneTwister, as in host.
    """
    names = b''.join(name.encode('utf-16-le').ljust(40, b'\x00')
                     for name in ('DM QA Player A', 'DM QA Player B'))
    body = names + struct.pack('<4I', 8000, 5, 1, 5 << 16)
    for deck in decks:
        body += struct.pack('<I', len(deck)) + struct.pack('<' + 'I' * len(deck), *deck) + struct.pack('<I', 0)
    body += b''.join((bytes([len(r)]) + r for r in responses))
    header = struct.pack('<6I', 0x31707279, 0x1349, 0, seed, len(body), 0) + bytes(8)
    path.write_bytes(header + body)


def load_replay(path):
    raw = path.read_bytes()
    if len(raw) < 128:
        raise ValueError('Truncated replay header')
    magic, version, flags, seed, size, _ = struct.unpack_from('<6I', raw)
    if magic != 0x31707279 or version != 0x1349 or flags != 0 or (len(raw) != 32 + size):
        raise ValueError('Invalid uncompressed YRP1 fixture')
    offset = 32 + 80
    settings = struct.unpack_from('<4I', raw, offset)
    offset += 16
    if settings != (8000, 5, 1, 5 << 16):
        raise ValueError('Unexpected fixture replay settings')
    decks = []
    for player in (0, 1):
        count = struct.unpack_from('<I', raw, offset)[0]
        offset += 4
        if count != 41 or offset + count * 4 + 4 > len(raw):
            raise ValueError('Invalid fixture deck boundary')
        decks.append(list(struct.unpack_from('<' + 'I' * count, raw, offset)))
        offset += count * 4
        extra = struct.unpack_from('<I', raw, offset)[0]
        offset += 4
        if extra:
            raise ValueError('Unexpected extra deck')
    responses = []
    while offset < len(raw):
        size = raw[offset]
        offset += 1
        if not 1 <= size <= 64 or offset + size > len(raw):
            raise ValueError('Invalid response boundary')
        responses.append(raw[offset:offset + size])
        offset += size
    return (seed, decks, responses)
FIRE = (24001070, 24001074, 24001080, 24003038, 24004042, 24004046, 24002038, 24003035, 24003042, 24001077)
NATURE = (24012015, 24001091, 24006109, 24010089, 24001095, 24006102, 24001096, 24006099, 24004055, 24004049)
# Four of each of ten ordinary cards, plus one engine-only rules support card.
# Priorities see only the player's own playable cards, never hidden shields.
SCENARIOS = {
    'shield-trigger-accept': (24000001, FIRE, (), False),
    'shield-trigger-decline': (24000001, FIRE, (), True),
    'spell-shield-trigger': (24000001, FIRE[:3] + (24001088,) + FIRE[4:], (), False),
    'double-breaker': (24000001, NATURE, (24012015,), False),
    'full-battle-zone-trigger': (24000007, NATURE, (), False)
}
CREATURE_TRIGGERS = {24004042, 24004049, 24004055}


def summarize(events):
    """Inspect actual movement/chain offers; no guessed face-down identities in AI.

    This offline evidence intentionally inspects the complete authoritative stream.
    It is not player-view telemetry and must not be sent to a live opponent.
    """
    metrics = collections.Counter()
    board = [set(), set()]
    shields = [set(), set()]
    hint = None
    chains = {}
    spell_chains = set()
    resolving = None
    active_player = None
    for packet in events:
        message = packet[0]
        if message == 40:
            active_player = packet[1]
        elif message == 2 and packet[1] == 3:
            hint = struct.unpack_from('<I', packet, 3)[0]
        elif message == 50:
            code = struct.unpack_from('<I', packet, 1)[0]
            old_player, old_location, old_sequence, old_position = packet[5:9]
            new_player, new_location, new_sequence, new_position = packet[9:13]
            if old_location == 4:
                board[old_player].discard(old_sequence)
            if new_location == 4:
                board[new_player].add(new_sequence)
            if old_location == 8 and old_sequence < 5:
                shields[old_player].discard(old_sequence)
            if new_location == 8 and new_sequence < 5:
                shields[new_player].add(new_sequence)
                if new_position & 10:
                    metrics['facedown_shield_placements'] += 1
            if old_location == 2 and new_location == 16:
                metrics['mana_charges'] += 1
            if old_location == 4 and new_location == 32 and new_position & 5 and (resolving in spell_chains):
                metrics['spell_trigger_creatures_destroyed'] += 1
            if old_location == 8 and old_sequence < 5 and old_position & 10 and (new_location == 2):
                metrics['broken_shields_to_hand'] += 1
                if code in CREATURE_TRIGGERS and len(board[new_player]) == 5:
                    metrics['trigger_broken_at_full_battle_zone'] += 1
            metrics['max_battle_zone_occupancy'] = max(
                metrics['max_battle_zone_occupancy'], *(len(b) for b in board))
        elif message == 15 and hint == 8603:
            metrics['shield_break_selections'] += 1
            if packet[3] >= 2:
                metrics['multi_break_selections'] += 1
        elif message == 16:
            for i in range(packet[2]):
                if struct.unpack_from('<I', packet, 22 + i * 14)[0] == 9663:
                    metrics['creature_trigger_offers'] += 1
        elif message == 70:
            if struct.unpack_from('<I', packet, 12)[0] == 9663:
                chains[packet[16]] = struct.unpack_from('<I', packet, 1)[0]
                metrics['creature_trigger_activations'] += 1
            # In this fixture, Tornado Flame can only be cast on the opponent's
            # turn through its Shield Trigger. Count resolution movement too.
            elif struct.unpack_from('<I', packet, 1)[0] == 24001088 and packet[9] != active_player:
                spell_chains.add(packet[16])
                metrics['spell_trigger_activations'] += 1
        elif message == 72:
            resolving = packet[1]
        elif message == 73:
            resolving = None
        elif message == 74:
            chains.clear()
            spell_chains.clear()
        elif message == 62:
            code = struct.unpack_from('<I', packet, 1)[0]
            if resolving in chains and chains[resolving] == code:
                metrics['creature_trigger_summons'] += 1
        elif message == 110:
            metrics['attacks'] += 1
        elif message == 63:
            metrics['summons'] += 1
    metrics['remaining_shields_player_0'] = len(shields[0])
    metrics['remaining_shields_player_1'] = len(shields[1])
    return dict(metrics)


def check_scenario(name, game, metrics):

    def require(condition, description):
        if not condition:
            raise AssertionError(f'{name}: {description}; metrics={metrics}')
    require(game['result'] == {'winner': 0, 'reason': 1}, 'ordinary player-zero attack win expected')
    for key in ('mana_charges', 'summons', 'attacks', 'broken_shields_to_hand'):
        require(metrics.get(key, 0) > 0, f'missing real {key}')
    require(metrics.get('facedown_shield_placements') == 10, 'both five-shield openings expected')
    require(metrics.get('remaining_shields_player_1') == 0, 'winner must break defending shields')
    if name == 'shield-trigger-accept':
        require(metrics.get('creature_trigger_offers', 0) > 0, 'missing trigger offer')
        require(metrics.get('creature_trigger_summons', 0) > 0, 'offered trigger must actually summon')
    elif name == 'shield-trigger-decline':
        require(metrics.get('creature_trigger_offers', 0) > 0, 'missing optional trigger offer')
        require(metrics.get('creature_trigger_activations', 0) == 0, 'declined trigger activated')
    elif name == 'double-breaker':
        require(metrics.get('multi_break_selections', 0) > 0, 'missing actual multi-shield break offer')
    elif name == 'spell-shield-trigger':
        require(metrics.get('spell_trigger_activations', 0) > 0, 'missing spell Shield Trigger cast')
        require(metrics.get('spell_trigger_creatures_destroyed', 0) > 0,
                'spell trigger did not destroy a creature')
    elif name == 'full-battle-zone-trigger':
        require(metrics.get('trigger_broken_at_full_battle_zone', 0) > 0,
                'regression must break a trigger with all five creature slots occupied')
        require(game['responses'] < 500, 'trigger reoffer loop regression')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--core', type=Path, required=True, help='Actual deployed native ocgcore DLL')
    parser.add_argument('--host-scripts', type=Path, required=True, help='Host Data/script.zip')
    parser.add_argument('--package', type=Path, help='Optional built YPK; otherwise use repository scripts')
    parser.add_argument('--output-dir', type=Path, required=True,
                        help='New directory for replays and receipts; existing paths are rejected')
    parser.add_argument('--scenario', choices=SCENARIOS, action='append', help='Default: all scenarios')
    args = parser.parse_args()
    # No overwrite: an unsuccessful run is acceptance evidence too.
    args.output_dir.mkdir(parents=True, exist_ok=False)
    runner = FullDuel(args.root, args.core, args.host_scripts, args.package)
    reports = []
    report_path = args.output_dir / 'report.json'
    receipt = {
        'passed': False,
        'scope': 'real native full games and saved/reloaded YRP1 response playback; Unity playback separate',
        'core_sha256': sha256(args.core),
        'host_scripts_sha256': sha256(args.host_scripts),
        'package_sha256': sha256(args.package) if args.package else None,
        'helper_sha256': sha256(args.root / 'expansions/utility_dmtcg.lua'),
        'scenarios': reports
    }
    try:
        # NativeSmoke reads card metadata from the source SQLite catalogs. A
        # packaged run is valid only when those catalogs match the tested YPK.
        if runner.package:
            databases = sorted((args.root / 'expansions').glob('*.cdb'))
            for database in databases:
                if runner.package.read(database.name) != database.read_bytes():
                    raise ValueError(f'Packaged database differs from source: {database.name}')
            helper = runner.package.read('script/dm/utility.lua')
            receipt['packaged_helper_sha256'] = hashlib.sha256(helper).hexdigest()
            if helper != (args.root / 'expansions/utility_dmtcg.lua').read_bytes():
                raise ValueError('Packaged DM helper differs from source')
        for name in args.scenario or SCENARIOS:
            seed, codes, priorities, decline = SCENARIOS[name]
            deck = [24000000] + [code for code in codes for _ in range(4)]
            if len(deck) != 41 or any((code not in runner.cards for code in deck)):
                raise ValueError(f'Invalid fixture deck: {name}')
            decks = [deck.copy(), deck.copy()]
            runner.priority_codes = set(priorities)
            runner.decline_triggers = decline
            first, events, responses = runner.game(
                seed, decks, failure_path=args.output_dir / f'{name}.failure.json')
            replay_path = args.output_dir / f'{name}.yrp'
            save_replay(replay_path, seed, decks, responses)
            loaded_seed, loaded_decks, loaded_responses = load_replay(replay_path)
            second, replayed_events, replayed_responses = runner.game(
                loaded_seed, loaded_decks, loaded_responses,
                args.output_dir / f'{name}.replay-failure.json')
            if first != second or events != replayed_events or responses != replayed_responses:
                raise AssertionError(f'Saved replay diverged: {name}')
            metrics = summarize(events)
            check_scenario(name, first, metrics)
            if runner.logs:
                raise AssertionError(f'Native script diagnostics: {runner.logs}')
            reports.append({
                'name': name, 'seed': seed, 'deck_card_ids': codes,
                'priority_card_ids': priorities,
                'decline_optional_creature_triggers': decline,
                'game': first, 'metrics': metrics, 'replay': replay_path.name,
                'replay_sha256': sha256(replay_path), 'saved_replay_exact_match': True
            })
        receipt['passed'] = True
    except Exception as error:
        receipt['error'] = str(error)
        raise
    finally:
        receipt['logs'] = runner.logs
        report_path.write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
        runner.close()
        print(json.dumps(receipt, indent=2))
if __name__ == '__main__':
    main()
