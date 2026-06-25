# 04 Sequences — Test It
# Use filter, map, and fold from sequtils to transform a sequence.
# Uses ONLY: seq, sequtils (filterIt, mapIt, foldl), concat.

import std/sequtils

let nums = @[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Pipeline: filter odds → square them → sum the result
let result = nums
  .filterIt(it mod 2 == 1)
  .mapIt(it * it)
  .foldl(a + b)

echo "Numbers: ", nums
echo "Odds squared and summed: ", result

# Try changing the filter to evens (it mod 2 == 0).
# Try using concat to join two transformed sequences.
# Try using countIt to count how many numbers are > 5.
