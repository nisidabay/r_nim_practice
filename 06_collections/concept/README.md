# 06 Collections — Tables, Sets, and Counting

## Quick Start

```bash
nim c -r 06_collections/concept/tables.nim
nim c -r 06_collections/concept/sets.nim
nim c -r 06_collections/concept/count_table.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `tables.nim` | Table, OrderedTable — key-value storage | `t[key] = value`, `hasKey`, `del`, `pairs()` |
| `sets.nim` | HashSet, OrderedSet, bit set | `incl/excl`, union/intersection/difference |
| `count_table.nim` | CountTable: frequency counting | `ct.inc(key)`, `ct.largest`, `toCountTable()` |

## Common Patterns

```nim
var t = {"name": "Carlos", "lang": "Nim"}.toTable
t["age"] = 42

var s: HashSet[int]
s.incl(1); s.incl(2)
echo 1 in s                     # true

var ct = @["nim", "rust", "nim"].toCountTable()
echo ct["nim"]                  # 2
```

## Now Build Your Own

Count word frequencies from a text file. Print the top 5 words by occurrence.
