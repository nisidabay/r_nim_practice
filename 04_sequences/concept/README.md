# 04 Sequences — Dynamic Arrays and Tuples

## Quick Start

```bash
nim c -r 04_sequences/concept/sequences.nim
nim c -r 04_sequences/concept/enums_tuples.nim
nim c -r 04_sequences/concept/sequtils.nim
nim c -r 04_sequences/concept/stats.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `sequences.nim` | seq[T]: add, slice, insert, delete, multi-dimensional | `@[]` for empty, `@[1,2,3]` literal, `[^1]` from end |
| `enums_tuples.nim` | Enums, tuples, unpacking | `Color = enum red, green, blue`; `let (x,y) = point` |
| `sequtils.nim` | map, filter, fold, zip, concat | Functional programming in Nim: pure transforms, pipeline with UFCS |
| `stats.nim` | std/stats | RunningStat, push, mean, variance, standardDeviation |

## Common Patterns

```nim
var nums = @[1, 2, 3]
nums.add(4)                     # @[1, 2, 3, 4]
nums.delete(0)                  # @[2, 3, 4]
echo nums[0..<2]                # @[2, 3]
nums.setLen(1)                  # @[2]

var named = (x: 5, y: 12)       # named tuple

# Functional pipeline (sequtils + UFCS)
@[1, 2, 3, 4, 5].filterIt(it mod 2 == 1).mapIt(it * it).foldl(a + b)
# odds → squares → sum = 35
```

## Test it

Run `test_it.nim` — it creates a sequence of numbers, sorts with `sort`,
and calculates the median. Change the numbers, change the size, use `map`
to transform them. Add a `filter` before sorting. Experiment.
