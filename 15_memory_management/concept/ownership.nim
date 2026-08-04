# Who owns this memory? — GC vs ARC vs manual
#   nim c -r ownership.nim
#
# Every value in Nim has a definite owner that decides when its memory
# dies. The rule is simple:
#   ref / seq / string  → the GC / ARC frees them automatically.
#   ptr (raw memory)    → YOU free them with dealloc.
#
# This matters: mixing up "who frees" is the #1 source of leaks and
# dangling pointers.

# ── ref: one shared object, freed when all aliases are gone ─────────────

type Resource = ref object
  name: string

proc makeResource(): Resource =
  result = Resource(name: "shared")

let a = makeResource()
let b = a                       # REFERENCE copy — same backing object
a.name = "mutated"
echo "aliases share the object: ", b.name   # "mutated"

# When `a` and `b` both go out of scope, the object is freed once. No
# manual free. No dangling pointers — the count reaches zero exactly once.

# ── value types: copied on assignment, each owns its own copy ───────────

type Point = object
  x, y: int

var p1 = Point(x: 1, y: 2)
var p2 = p1                     # VALUE copy — p2 owns its own Point
p2.x = 99
echo "value copies are separate: p1.x=", p1.x, " p2.x=", p2.x  # 1 vs 99

# ── raw memory: you own it, you free it ─────────────────────────────────

let count = 3
var buf = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * count))
buf[0] = 10
buf[1] = 20
buf[2] = 30
echo "raw buf[1] = ", buf[1]    # 20
dealloc(buf)                    # YOUR job — the GC does not know about buf

# Skip the dealloc and the program still "works" — it just leaks. That's
# why raw memory is opt-in: the language hands you the power and the risk.

# ── =destroy: hook that runs when an object is freed ────────────────────

type Logger = object
  path: string
  open: bool

proc `=destroy`(l: var Logger) =
  # Called automatically when a Logger goes out of scope. Use it to
  # release resources the GC does not see — file handles, sockets.
  echo "=destroy: closing ", l.path

proc runLogging() =
  var log = Logger(path: "/tmp/app.log", open: true)
  echo "using logger: ", log.path
  # when runLogging() returns, `=destroy` fires — no leak, no manual close
runLogging()
echo "after runLogging() — Logger was destroyed automatically"

# ── The ownership law ───────────────────────────────────────────────────
#   ref / seq / string   → let ARC free them. Do not dealloc.
#   ptr from alloc       → you dealloc, exactly once, on every path.
#   object with =destroy → resources released at scope exit automatically.
# Choose ref / seq / string by default. Only drop to ptr when you must.

# ── Thinking in Nim ────────────────────────────
# Nim's ownership rule is decided by TYPE, not by convention: `ref`,
# `seq`, and `string` are reference-counted and free themselves; a value
# `object` is copied on assignment so each copy owns its memory; a raw
# `ptr` from `alloc` is yours alone to dealloc. `=destroy` lets a value
# object release non-memory resources on scope exit. Pick the type whose
# ownership matches how long the data must live — most code should never
# call dealloc at all.
