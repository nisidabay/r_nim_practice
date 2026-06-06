# 04 Sequences — Dynamic Arrays and Tuples

## Quick Start

```bash
nim c -r 04_sequences/concept/sequences.nim
nim c -r 04_sequences/concept/enums_tuples.nim
nim c -r 04_sequences/concept/sequtils.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `sequences.nim` | seq[T]: add, slice, insert, delete, multi-dimensional | `@[]` for empty, `@[1,2,3]` literal, `[^1]` from end |
| `enums_tuples.nim` | Enums, tuples, unpacking | `Color = enum red, green, blue`; `let (x,y) = point` |
| `sequtils.nim` | map, filter, fold, zip, concat | Functional sequence operations |

## Common Patterns

```nim
var nums = @[1, 2, 3]
nums.add(4)                     # @[1, 2, 3, 4]
nums.delete(0)                  # @[2, 3, 4]
echo nums[0..<2]                # @[2, 3]
nums.setLen(1)                  # @[2]

var named = (x: 5, y: 12)       # named tuple
```

## Now Build Your Own

Write a program that creates a sequence of 5 random numbers, sorts them,
and prints the median.
