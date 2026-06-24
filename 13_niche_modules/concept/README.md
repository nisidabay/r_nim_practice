# 13 Niche Modules — Stats, Colors, and Sugar

## Quick Start

```bash
nim c -r 13_niche_modules/concept/stats.nim
nim c -r 13_niche_modules/concept/colors.nim
nim c -r 13_niche_modules/concept/mini_modules.nim
```

## Learning Path

| File | Module | Key Pattern |
|------|--------|-------------|
| `stats.nim` | std/stats | `RunningStat`, incremental mean/variance/stddev |
| `colors.nim` | std/colors | `parseColor`, `extractRGB`, ANSI color output |
| `mini_modules.nim` | sugar + lenientops + enumutils | `=>` lambda, `dump`, `collect`, implicit int↔float |

## Common Patterns

```nim
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

Build a CLI tool that reads numeric data from a text file (one number per
line), computes statistics (mean, variance, stddev), and prints a color-coded
report using ANSI escapes via the `colors` module.