# 01 Basics — Your First Nim Programs

## Quick Start

```bash
nim c -r 01_basics/concept/hello.nim
nim c -r 01_basics/concept/types.nim
nim c -r 01_basics/concept/input.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `hello.nim` | Compilation, echo, variables | `nim c -r` compiles AND runs |
| `types.nim` | Int, float, string, char, bool | Type inference with `let`, annotation with `var` |
| `input.nim` | readLine, command-line args | `paramStr(i)` reads argv, `readLine(stdin)` |

## Common Patterns

```nim
let name = "Carlos"         # immutable
var age = 42                # mutable
const PI = 3.14159         # compile-time
echo name, " is ", age      # comma-separated output
```

## Pónlo a prueba

Coge `hello.nim` y `input.nim`, combínalos: pide un nombre y año de
nacimiento, calcula la edad. Cambia el mensaje, cambia el formato.
Sin presión — solo prueba y ve qué pasa.
