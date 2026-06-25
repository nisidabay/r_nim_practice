# 11 Stdlib Essentials — JSON, Algorithm, Modules, Arrays, Random

## Quick Start

```bash
nim c -r 11_stdlib/concept/algorithm.nim
nim c -r 11_stdlib/concept/json.nim
nim c -r 11_stdlib/concept/modules.nim
nim c -r 11_stdlib/concept/arrays.nim
nim c -r 11_stdlib/concept/random.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `algorithm.nim` | sort, reverse, binarySearch, fill, isSorted | `sort(Descending)`, `reversed()` iterator vs `reverse()` proc |
| `json.nim` | parseJson, construct, serialize, roundtrip | `parseJson(raw)`, `%*[1,2,3]`, `pretty()` |
| `modules.nim` | import, include, export mechanics | `import helper`, `export module_a` |
| `arrays.nim` | array[N,T], compile-time bounds, vs seq, multi-dim | `array[5, int]`, `matrix[i][j]` |
| `random.nim` | Random numbers, shuffle, sample | `rand(n)`, `sample(population)`, `shuffle(seq)` |

## Common Patterns

```nim
import std/[json, algorithm]

let data = parseJson(readFile("config.json"))
sort(mySeq, Descending)
import std/random; randomize()
let pick = sample(@["a", "b", "c"])
```

## Pónlo a prueba

Coge `json.nim` y `algorithm.nim`, combínalos: parsea un JSON, ordénalo,
imprime un resumen. Cambia los datos, cambia el criterio de ordenación,
añade un campo nuevo. Sin presión — solo juega con los módulos.