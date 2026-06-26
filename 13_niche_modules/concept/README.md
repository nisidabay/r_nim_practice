# 13 Niche Modules — Stats, Times, and Specialized Stdlib

## Quick Start

```bash
nim c -r 13_niche_modules/concept/stats.nim
nim c -r 13_niche_modules/concept/times.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `stats.nim` | Online statistics (running mean, variance, stddev) | `RunningStat.push()`, `s.mean`, `s.standardDeviation` |
| `times.nim` | Datetime, formatting, duration, Unix timestamps | `now()`, `format("yyyy-MM-dd HH:mm:ss")`, `parse()`, `initDuration(days=3)`, `toUnix`/`fromUnix` |

## Common Patterns

```nim
import std/times

# Timestamp for logs
echo now().format("yyyy-MM-dd HH:mm:ss")

# File age check
let age = now() - parse("2025-01-01", "yyyy-MM-dd")
echo "Days since: ", age.inDays

# Unix roundtrip
let ts = now().toTime.toUnix
assert now().format("yyyy-MM-dd") == fromUnix(ts).local.format("yyyy-MM-dd")
```

## Test it

Run `test_it.nim` — it feeds numbers into `RunningStat` and shows how
mean and standard deviation change when you add extreme values.
