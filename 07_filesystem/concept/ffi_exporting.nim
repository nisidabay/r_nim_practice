# Export Nim procs as C symbols. Build a .so that C/Python/Go can call.
#   nim c --app:lib --out:libnimmath.so ffi_exporting.nim
#
# Python test:
#   import ctypes
#   lib = ctypes.CDLL("./libnimmath.so")
#   print(lib.nim_add(5, 3))

import std/tables

# ── Export simple functions ───────────────────────────────────────────

proc add(a, b: cint): cint {.exportc: "nim_add".} =
  a + b

proc multiply(a, b: cint): cint {.exportc: "nim_mul".} =
  a * b


# ── Export with string handling (cstring at boundary) ─────────────────

proc greet(name: cstring): cstring {.exportc: "nim_greet".} =
  var nimName = $name                                      # cstring → string
  var nimGreeting = "Hello, " & nimName & "! From Nim."
  echo "Nim: prepared greeting for ", nimName
  result = nimGreeting.cstring                              # string → cstring


# ── Export with real Nim data structures ──────────────────────────────

var userDb = {
  "carlos": "admin",
  "alice": "viewer",
  "bob": "editor"
}.toTable()

proc checkAccess(username: cstring): cint {.exportc: "nim_check_access".} =
  # Returns: 1 = admin, 0 = allowed, -1 = unknown
  let name = $username
  if name in userDb:
    let role = userDb[name]
    echo "Nim: checking ", name, " (", role, ")"
    result = if role == "admin": 1 else: 0
  else:
    echo "Nim: unknown user ", name
    result = -1

# C callers get a fast .so. Nobody knows it's Nim.
# No runtime, no VM — just machine code with C symbols.
