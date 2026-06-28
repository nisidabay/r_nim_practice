# 11 Stdlib Essentials — JSON, Algorithm, Modules, Random, Stats, Times

## Quick Start

```bash
nim c -r 11_stdlib/concept/algorithm.nim
nim c -r 11_stdlib/concept/json.nim
nim c -r 11_stdlib/concept/modules.nim
nim c -r 11_stdlib/concept/random.nim
nim c -r 11_stdlib/concept/stats.nim
nim c -r 11_stdlib/concept/times.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `algorithm.nim` | sort, reverse, binarySearch, fill, isSorted | `sort(Descending)`, `reversed()` iterator vs `reverse()` proc |
| `json.nim` | parseJson, construct, serialize, roundtrip | `parseJson(raw)`, `%*[1,2,3]`, `pretty()` |
| `modules.nim` | import, include, export mechanics | `import helper`, `export module_a` |
| `random.nim` | Random numbers, shuffle, sample | `rand(n)`, `sample(population)`, `shuffle(seq)` |
| `stats.nim` | Online statistics (running mean, variance, stddev) | `RunningStat.push()`, `s.mean`, `s.standardDeviation` |
| `times.nim` | Datetime, formatting, duration, Unix timestamps | `now()`, `format("yyyy-MM-dd HH:mm:ss")`, `parse()`, `initDuration(days=3)`, `toUnix`/`fromUnix` |

## Common Patterns

```nim
import std/[json, algorithm, random]

let data = parseJson(readFile("config.json"))
sort(mySeq, Descending)
import std/random; randomize()
let pick = sample(@["a", "b", "c"])

# Stats
var s: RunningStat
s.push(42.0)
echo s.mean, " ", s.standardDeviation

# Dates
echo now().format("yyyy-MM-dd HH:mm:ss")
let ts = now().toTime.toUnix
```

## Test it

Run `test_it.nim` — it combines JSON parsing with sorting: parse JSON
data, sort it, print a summary. Change the data, change the sort key,
add a new field. No pressure — just play with the modules.
