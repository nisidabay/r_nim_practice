# 05 Strings — Manipulation, Parsing, and Regex

## Quick Start

```bash
nim c -r 05_strings/concept/strutils.nim
nim c -r 05_strings/concept/string_format.nim
nim c -r 05_strings/concept/parse_demo.nim
nim c -r 05_strings/concept/regex.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `strutils.nim` | Case, strip, split, join, find, replace | 30+ string ops in one tour |
| `string_format.nim` | Alignment, float formatting, unicode | `align/alignLeft/center`, `fmt"{x:.2f}"` |
| `parse_demo.nim` | parseInt, parseFloat, parseHexInt, parseEnum | Safe string→type conversion |
| `regex.nim` | re module: find, match, replace, capture groups | `re"(pattern)"`, `findAll`, `replace` |

## Common Patterns

```nim
import std/strutils
let parts = "a,b,c".split(',')       # @["a", "b", "c"]
echo parts.join(" | ")               # "a | b | c"
echo parseInt("42")                   # 42
echo fmt"{3.14159:.2f}"              # 3.14
```

## Test it

Run `test_it.nim` — it takes a CSV line ("name,age,city"), splits with
`split(",")`, strips whitespace with `strip`, and prints it aligned.
Change the separator, add more columns, add a header. No pressure — just try.
