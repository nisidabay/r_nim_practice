# 06 Collections — Tables, Sets, and Counting

## Quick Start

```bash
nim c -r 06_collections/concept/tables.nim
nim c -r 06_collections/concept/sets.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `tables.nim` | Table, OrderedTable — key-value storage | `t[key] = value`, `hasKey`, `del`, `pairs()` |
| `sets.nim` | HashSet, OrderedSet, bit set | `incl/excl`, union/intersection/difference |

## Common Patterns

```nim
var t = {"name": "Carlos", "lang": "Nim"}.toTable
t["age"] = 42

var s: HashSet[int]
s.incl(1); s.incl(2)
echo 1 in s                     # true

# CountTable lives in tables.nim:
var ct = @["nim", "rust", "nim"].toCountTable()
echo ct["nim"]                  # 2
```

## Pónlo a prueba

Coge un texto, pásalo a `toCountTable()`, saca las 5 palabras más
frecuentes. Cambia el texto, prueba con `sortedBy` en vez de `sort`,
filtra palabras cortas. Dale vueltas.
