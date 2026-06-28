# 04 Sequences — seq[T], array[N,T], and sequtils

## Quick Start

```bash
nim c -r 04_sequences/concept/sequences.nim
nim c -r 04_sequences/concept/arrays.nim
nim c -r 04_sequences/concept/sequtils.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `sequences.nim` | seq[T]: add, slice, insert, delete, multi-dimensional | `@[]` for empty, `@[1,2,3]` literal, `[^1]` from end |
| `arrays.nim` | array[N,T], compile-time bounds, vs seq, multi-dim, openArray | `array[5, int]`, `matrix[i][j]`; `openArray[T]` accepts both array and seq |
| `sequtils.nim` | map, filter, fold, zip, concat | Functional programming in Nim: pure transforms, pipeline with UFCS |

## Common Patterns

```nim
var nums = @[1, 2, 3]
nums.add(4)                     # @[1, 2, 3, 4]
nums.delete(0)                  # @[2, 3, 4]
echo nums[0..<2]                # @[2, 3]
nums.setLen(1)                  # @[2]

var arr: array[4, int] = [1, 2, 3, 4]

# openArray accepts both
proc sum(data: openArray[int]): int =
  for x in data: result += x
echo sum(arr)                    # 10
echo sum(nums)                   # 2

# Functional pipeline (sequtils + UFCS)
@[1, 2, 3, 4, 5].filterIt(it mod 2 == 1).mapIt(it * it).foldl(a + b)
# odds → squares → sum = 35
```

## Test it

Run `test_it.nim` — it creates a sequence of numbers, uses filter/map/fold
from sequtils. Change the numbers, change the transforms, try with arrays.
Experiment.
