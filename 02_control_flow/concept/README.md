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
| `iterators.nim` | Custom iterators, yield | `iterator name(params): type = body`; `yield` returns one value at a time; `{.inline.}` pragma for speed |

## Common Patterns

```nim
if score >= 90: echo "A"
elif score >= 80: echo "B"
else: echo "C"

for i in 1..5: echo i
while x < 3: x += 1
```

## Pónlo a prueba

Coge `loops.nim`, mete un for dentro de otro for. Imprime una tabla de
multiplicar del 1 al 5. Cambia el rango, cambia el formato, usa `while`
en vez de `for`. Juega con ello.
