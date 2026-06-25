# 13 Niche Modules — Stats and Sugar

## Quick Start

```bash
nim c -r 13_niche_modules/concept/stats.nim
nim c -r 13_niche_modules/concept/mini_modules.nim
```

## Learning Path

| File | Module | Key Pattern |
|------|--------|-------------|
| `stats.nim` | std/stats | `RunningStat`, incremental mean/variance/stddev |
| `mini_modules.nim` | sugar + lenientops + enumutils | `=>` lambda, `dump`, `collect`, implicit int↔float |

## Common Patterns

```nim
import std/stats
var s: RunningStat
s.push([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0])
echo s.mean, " ± ", s.standardDeviation

import std/sugar
let square = (x: int) => x * x
```

## Pónlo a prueba

Coge `stats.nim`: métete números, mira cómo cambian la media y la
desviación al añadir valores extremos. Prueba con 10 números, luego
con 1000. Combínalo con `mini_modules.nim` y usa `=>` para las funciones.