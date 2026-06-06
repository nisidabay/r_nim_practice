# 02 Control Flow — Decisions and Loops

## Quick Start

```bash
nim c -r 02_control_flow/concept/control_flow.nim
nim c -r 02_control_flow/concept/loops.nim
nim c -r 02_control_flow/concept/iterators.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `control_flow.nim` | if/elif/else, case/of | No parens, indentation is the block |
| `loops.nim` | for, while, break, continue | `1..5` inclusive, `0..<5` exclusive, `countdown(5,1)` |
| `iterators.nim` | Custom iterators, yield | `yield` returns one value at a time; `{.inline.}` for speed |

## Common Patterns

```nim
if score >= 90: echo "A"
elif score >= 80: echo "B"
else: echo "C"

for i in 1..5: echo i
while x < 3: x += 1
```

## Now Build Your Own

Write a program that prints a multiplication table (1×1 through 5×5) using nested for loops. Format the output as a grid.
