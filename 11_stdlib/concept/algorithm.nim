# std/algorithm — sorting, searching, reversing, filling, iterating
#   nim c -r concept/algorithm.nim

import std/algorithm

# ── Sorting ──────────────────────────────────────────────────────────────

var nums = @[3, 1, 4, 1, 5, 9, 2]
nums.sort()
echo "sort: ", nums                      # @[1, 1, 2, 3, 4, 5, 9]

# Sort descending
nums.sort(Descending)
echo "descending: ", nums                 # @[9, 5, 4, 3, 2, 1, 1]

# Custom sort (by absolute value)
var mixed = @[-5, 3, -2, 1, -4]
mixed.sort(cmp = proc(a, b: int): int = abs(a) - abs(b))
echo "by abs: ", mixed                    # @[1, -2, 3, -4, -5]

# ── Reversing ────────────────────────────────────────────────────────────

var letters = @['a', 'b', 'c', 'd']
letters.reverse()
echo "reverse: ", letters                 # @['d', 'c', 'b', 'a']

# Reversed iterator (non-mutating)
let original = @[1, 2, 3]
var collected: seq[int] = @[]
for x in reversed(original):
  collected.add(x)
echo "reversed() iter: ", collected       # @[3, 2, 1]
echo "original unchanged: ", original     # @[1, 2, 3]

# ── Searching ────────────────────────────────────────────────────────────

let sorted = @[1, 3, 5, 7, 9]
echo "binarySearch(5) = ", sorted.binarySearch(5)   # 2
echo "binarySearch(6) = ", sorted.binarySearch(6)   # -1 (not found)

# ── Filling ──────────────────────────────────────────────────────────────

var zeros = newSeq[int](5)
zeros.fill(42)
echo "fill(42): ", zeros                  # @[42, 42, 42, 42, 42]

# ── Checking ─────────────────────────────────────────────────────────────

echo "isSorted(@[1,2,3]) = ", @[1, 2, 3].isSorted()       # true
echo "isSorted(@[3,2,1]) = ", @[3, 2, 1].isSorted()       # false