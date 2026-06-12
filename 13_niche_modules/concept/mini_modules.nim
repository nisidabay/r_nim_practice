# std/sugar + std/lenientops + std/enumutils — syntactic sugar
#   nim c -r concept/mini_modules.nim

import std/sugar, std/lenientops, std/enumutils

# ── std/sugar: => lambda syntax ─────────────────────────────────────────

let double = (x: int) => x * 2
echo "double(21) = ", double(21)

let add = (a, b: int) => a + b
echo "add(3, 4) = ", add(3, 4)

# ── std/sugar: dump (print with name=value) ────────────────────────────

let msg = "hello"
let count = 42
dump(msg)
dump(count)

# ── std/sugar: collect (comprehensions) ─────────────────────────────────

let evens = collect(newSeq):
  for x in 1..10:
    if x mod 2 == 0:
      x
echo "Evens 1..10: ", evens

# ── std/lenientops: implicit int↔float conversion ───────────────────────

let x = 5
let y = 3.14
echo "int + float = ", x + y         # 8.14 (no explicit float() needed)
echo "int == float? ", (5 == 5.0)    # true

# ── std/enumutils: enumerating enum members ─────────────────────────────

type ColorEnum {.pure.} = enum
  Red, Green, Blue, Yellow, Purple

echo "Enum members:"
for c in ColorEnum:
  echo "  ", c, " (ord: ", ord(c), ")"

# ── Verification ────────────────────────────────────────────────────────

assert double(21) == 42
assert add(3, 4) == 7
assert evens == @[2, 4, 6, 8, 10]
assert x + y == 8.14

echo "All mini_modules assertions passed."