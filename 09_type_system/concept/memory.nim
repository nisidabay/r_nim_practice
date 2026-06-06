# ARC (Automatic Reference Counting): the compiler inserts retain/release
# calls at compile time. No tracing GC, no pauses, deterministic frees.
#   nim c --mm:arc -r arc_memory.nim

# ── The compiler tracks the last use of every variable ────────────────

proc tempAlloc() =
  var buf = newString(1024 * 1024)   # 1MB
  buf[0] = 'H'
  echo "Created 1MB string"
  # buf dies here — ARC frees immediately. No GC cycle needed.

tempAlloc()
echo "Memory freed — no pause, no GC trigger"


# ── Move semantics with sink: transfer ownership, don't copy ─────────

proc takeIt(data: sink seq[int]) =
  echo "I own this: ", data.len, " elements"
  # data freed when proc returns

var numbers = @[10, 20, 30, 40]
takeIt(numbers)
# numbers was MOVED — it's now empty. No copy happened.


# ── Custom hooks for your types ───────────────────────────────────────

type
  Buffer = object
    data: seq[byte]
    owner: string

proc `=destroy`(b: var Buffer) =
  b.data = @[]

proc `=wasMoved`(b: var Buffer) =
  b.owner = ""

# ARC calls these automatically. You override when you need special cleanup.


# ── ARC vs ORC vs GC ──────────────────────────────────────────────────
#   ARC:  no cycles → perfect, zero overhead (servers, CLIs, parsers)
#   ORC:  possible cycles → ARC + cycle detector (graphs, linked lists)
#   GC:   legacy default, pauses but works everywhere
# Switch: --mm:arc / --mm:orc / --mm:refc — same code, different strategy.
