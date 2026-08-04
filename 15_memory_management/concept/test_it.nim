# 15 Memory Management — Test It
# Combines the group's three concepts in one program:
#   - a traced ref object (GC/ARC frees it automatically)
#   - a raw ptr buffer (alloc0 / dealloc — you are the owner)
#   - an ordinal conversion with ord() (casting without cast[])
#
# Run: nim c -r --hints:off test_it.nim

# ── Concept 1: ref object ────────────────────────────────────────────
# A traced reference. We create it, use it, and let ARC free it.

type Counter = ref object
  name: string
  count: int

proc bump(c: Counter): int =
  c.count += 1          # `.` derefs implicitly, mutates the shared object
  return c.count

var counter = Counter(name: "visits")
echo "ref start:  ", counter.name, " count = ", counter.count
echo "ref bump1:  ", bump(counter)
echo "ref bump2:  ", bump(counter)
# No dealloc needed — `counter` is a ref, ARC frees it at scope exit.

# ── Concept 2: raw memory ────────────────────────────────────────────
# Untraced heap. The GC does NOT watch it — our dealloc must free it.

let length = 4
var buf = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * length))
for i in 0 ..< length:
  buf[i] = (i + 1) * 10
echo "raw buffer: ", buf[0], ", ", buf[1], ", ", buf[2], ", ", buf[3]
dealloc(buf)              # REQUIRED — the GC won't free raw memory

# ── Concept 3: ordinal conversion ────────────────────────────────────
# Nim converts ordinals with ord() and back with chr() — no cast[] needed.

let letter = 'D'
echo "ord('D')  = ", ord(letter)      # 68
echo "chr(65)   = ", chr(65)          # 'A'

# ── Tie it together ──────────────────────────────────────────────────
# One alloc0'd int cell, written through a ptr and read back with `.` on
# a ref. Shows ptr (raw) and ref (traced) both deref with `[]`/`.`.

var cell = cast[ptr int](alloc0(sizeof(int)))
cell[] = ord(letter) * 2
echo "cell[]    = ", cell[]           # 136 = ord('D') * 2
dealloc(cell)
echo "test_it.nim done — ref freed itself, raw memory was dealloc'd"
