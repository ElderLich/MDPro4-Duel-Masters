"""Run bounded Lua regressions with a supplied Lua 5.3/5.4 executable or DLL.

No runtime binary is bundled. The DLL path is explicit and never discovered from
untrusted package contents. Native Lua and this optional ctypes bridge execute
the same test files, each in a fresh state.
"""

from __future__ import annotations

import argparse
import ctypes
from pathlib import Path
import subprocess
import sys


def run_with_dll(dll_path: Path, test: Path, root: Path) -> None:
    lua = ctypes.CDLL(str(dll_path.resolve(strict=True)))
    lua.luaL_newstate.argtypes = []
    lua.luaL_newstate.restype = ctypes.c_void_p
    lua.luaL_openlibs.argtypes = [ctypes.c_void_p]
    lua.luaL_openlibs.restype = None
    lua.luaL_loadbufferx.argtypes = [ctypes.c_void_p, ctypes.c_char_p,
                                   ctypes.c_size_t, ctypes.c_char_p, ctypes.c_char_p]
    lua.luaL_loadbufferx.restype = ctypes.c_int
    lua.lua_pcallk.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int,
                             ctypes.c_int, ctypes.c_ssize_t, ctypes.c_void_p]
    lua.lua_pcallk.restype = ctypes.c_int
    lua.lua_tolstring.argtypes = [ctypes.c_void_p, ctypes.c_int,
                                ctypes.POINTER(ctypes.c_size_t)]
    lua.lua_tolstring.restype = ctypes.c_char_p
    lua.lua_close.argtypes = [ctypes.c_void_p]
    lua.lua_close.restype = None
    state = lua.luaL_newstate()
    if not state:
        raise RuntimeError("Lua could not allocate a state")
    try:
        lua.luaL_openlibs(state)
        content = test.read_bytes()
        status = lua.luaL_loadbufferx(state, content, len(content),
                                     ("@" + test.relative_to(root).as_posix()).encode(), b"t")
        if status == 0:
            status = lua.lua_pcallk(state, 0, 0, 0, 0, None)
        if status:
            message = lua.lua_tolstring(state, -1, None)
            raise RuntimeError(message.decode("utf-8", "replace") if message
                               else f"Lua failed with status {status}")
    finally:
        lua.lua_close(state)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    runtime = parser.add_mutually_exclusive_group()
    runtime.add_argument("--lua", default="lua", help="Lua 5.3/5.4 executable")
    runtime.add_argument("--lua-dll", type=Path, help="Lua 5.3/5.4 shared library")
    parser.add_argument("tests", nargs="*", type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    tests = args.tests or [Path("tests/rules_regression.lua")]
    # Executing the bridge in a child keeps every test's native state and cwd
    # separate from the invoking process, and applies the same finite timeout.
    for relative in tests:
        test = (root / relative).resolve(strict=True)
        test.relative_to(root)
        if args.lua_dll:
            command = [sys.executable, str(Path(__file__).resolve()),
                       "--internal-dll", str(args.lua_dll.resolve()), str(test)]
        else:
            command = [args.lua, str(test)]
        subprocess.run(command, cwd=root, check=True, timeout=30)
    return 0


if __name__ == "__main__":
    try:
        if len(sys.argv) == 4 and sys.argv[1] == "--internal-dll":
            run_with_dll(Path(sys.argv[2]), Path(sys.argv[3]), Path(__file__).resolve().parents[1])
        else:
            raise SystemExit(main())
    except (OSError, ValueError, RuntimeError, subprocess.SubprocessError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
