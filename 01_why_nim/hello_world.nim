# Nim compiles to C, then to a native binary. No interpreter, no VM.
#   nim c -r hello_world.nim    # compile & run
#   nim r hello_world.nim       # shortcut

echo "Hello, Nim!"

# ── var, let, const: three levels of mutability ───────────────────────

var age = 30               # mutable
age = 31

let name = "Carlos"        # immutable — set once
# name = "Bob"              # compile ERROR
echo name                    # "Carlos"

const PI = 3.14159         # compile-time — baked into binary, no allocation
echo "π = ", PI

# ── Type inference: you rarely annotate ───────────────────────────────

var score = 0              # int
let greeting = "Hello"     # string
var active = true          # bool

# Explicit when clarity demands:
let price: float = 9.99
var buffer: seq[int] = @[]   # seq = dynamic array, @[] = empty


# ── Release build: optimized, standalone binary ───────────────────────
#   nim c -d:release -r hello_world.nim
#   ls -lh hello_world        # no runtime, no pip install, just ship it
