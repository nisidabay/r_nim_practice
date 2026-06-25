# 04 Sequences — Test It
# Use filter, map, and fold from sequtils to transform a sequence.
# Uses ONLY: seq, sequtils (filter, map, fold via loop), concat.

import std/sequtils

let nums = @[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Pipeline: filter odds → square them → sum the result
let odds = nums.filter(proc(x: int): bool = x mod 2 == 1)
let squares = odds.map(proc(x: int): int = x * x)
var sum = 0
for s in squares:
  sum += s

echo "Numbers: ", nums
echo "Odds squared and summed: ", sum

# Try changing the filter to evens (x mod 2 == 0).
# Try using concat to join two transformed sequences.
# Try using count to count how many numbers are > 5.
