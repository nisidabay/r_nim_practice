# 11 Stdlib Essentials — Math, OS, JSON, Algorithm, Modules, Arrays

## Quick Start

```bash
nim c -r 11_stdlib/concept/math.nim
nim c -r 11_stdlib/concept/algorithm.nim
nim c -r 11_stdlib/concept/os_module.nim
nim c -r 11_stdlib/concept/json.nim
nim c -r 11_stdlib/concept/modules.nim
nim c -r 11_stdlib/concept/arrays.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `math.nim` | sqrt, pow, trig, log, rounding, constants | `math.sqrt(144.0)`, `degToRad(180.0)` |
| `algorithm.nim` | sort, reverse, binarySearch, fill, isSorted | `sort(Descending)`, `reversed()` iterator vs `reverse()` proc |
| `os_module.nim` | Environment, sleep, exec, dir/file ops | `getEnv("PATH")`, `createDir()`, `moveFile()` |
| `json.nim` | parseJson, construct, serialize, roundtrip | `parseJson(raw)`, `%*[1,2,3]`, `pretty()` |
| `modules.nim` | import, include, export mechanics | `import helper`, `export module_a` |
| `arrays.nim` | array[N,T], compile-time bounds, vs seq, multi-dim | `array[5, int]`, `matrix[i][j]` |

## Common Patterns

```nim
import std/[math, json, os, algorithm]

let avg = mean(@[1.0, 2.0, 3.0])
let data = parseJson(readFile("config.json"))
sort(mySeq, Descending)
let home = getHomeDir()
```

## Now Build Your Own

Write a system info tool (like `project/sysinfo.nim`): read a JSON config
from `~/.nimrinfo`, query OS info via `std/os`, compute math stats on
numeric data, sort results with `std/algorithm`, and format output with
a custom formatter module.