# 13 Niche Modules — Rationals, Ropes, XML, and More

## Quick Start

```bash
nim c -r 13_niche_modules/concept/rationals.nim
nim c -r 13_niche_modules/concept/ropes.nim
nim c -r 13_niche_modules/concept/xmlparser.nim
nim c -r 13_niche_modules/concept/strscans.nim
nim c -r 13_niche_modules/concept/stats.nim
nim c -r 13_niche_modules/concept/colors.nim
nim c -r 13_niche_modules/concept/mini_modules.nim
```

## Learning Path

| File | Module | Key Pattern |
|------|--------|-------------|
| `rationals.nim` | std/rationals | `//` operator, exact fraction arithmetic, `toFloat` conversion |
| `ropes.nim` | std/ropes | `rope()`, `&` O(1) append, `$` conversion |
| `xmlparser.nim` | std/parsexml | SAX event loop, `xmlElementStart`/`xmlAttribute`/`xmlCharData` |
| `strscans.nim` | std/strscans | `scanf` with `$+`/`$i`/`$f` pattern tokens |
| `stats.nim` | std/stats | `RunningStat`, incremental mean/variance/standardDeviation |
| `colors.nim` | std/colors | `rgb()`, `parseColor`, `extractRGB`, named colors |
| `mini_modules.nim` | sugar + lenientops + enumutils | `=>` lambda, `dump`, `collect`, implicit int↔float |

## Common Patterns

```nim
import std/rationals
let r = 1 // 3 + 1 // 6        # exact arithmetic: 1/2
echo toFloat(r)                 # 0.5

import std/strscans
var name: string; var age: int
discard scanf("Name: Bob Age: 42", "Name: $+ Age: $i", name, age)

import std/stats
var s: RunningStat
s.push([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0])
echo s.mean, " ± ", s.standardDeviation

import std/colors
let c = parseColor("steelblue")
let (r, g, b) = extractRGB(c)

import std/sugar
let square = (x: int) => x * x
```

## Now Build Your Own

Build a data analysis CLI tool that loads numeric values from an XML file,
computes exact rational sums and floating-point statistics, then outputs a
color-coded report using ropes for efficient string assembly.