# 12 Ecosystem & Tooling — Stdlib Modules, Pragmas, Nimble, OOP

## Quick Start

```bash
nim c -r 12_ecosystem_tooling/concept/logging.nim
nim c -r 12_ecosystem_tooling/concept/parsecfg.nim
nim c -r 12_ecosystem_tooling/concept/parsecsv.nim
nim c -r 12_ecosystem_tooling/concept/pragmas.nim
nim c -r 12_ecosystem_tooling/concept/nimble.nim
nim c -r 12_ecosystem_tooling/concept/oop.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `logging.nim` | Structured logging with levels and handlers | `newConsoleLogger`, `addHandler`, `info`/`warn`/`error` |
| `parsecfg.nim` | INI-style config file parsing | `loadConfig`, `getSectionValue`, `sections` |
| `parsecsv.nim` | CSV file parsing with header support | `CsvParser`, `open`/`readRow`/`close`, `row["header"]` |
| `pragmas.nim` | Compiler directives and optimization | `{.inline.}`, `{.compileTime.}`, `{.used.}` |
| `nimble.nim` | Nimble packaging format reference | `.nimble` fields, `require`, `bin`, `task` |
| `oop.nim` | Ref objects, inheritance, method dispatch | `ref object`, `of` inheritance, `method` vs `proc` |

## Common Patterns

```nim
import std/[logging, parsecfg, parsecsv]

# Structured logging
addHandler(newConsoleLogger(fmtStr = "$levelid: $msg"))
info("Processing started")

# Config parsing
var cfg = loadConfig("config.ini")
let host = cfg.getSectionValue("server", "host")

# CSV parsing
var p: CsvParser; p.open("data.csv", ',', '"')
p.readHeaders()
while p.readRow(): echo p.row["name"]

# OOP: method dispatch
method speak(a: Animal): string {.base.}
method speak(d: Dog): string = "Woof!"
```

## Test it

Run `test_it.nim` — it combines config (parsecfg), CSV data, structured
logging, and OOP models. A config file defines colors, a CSV holds data,
logging prints it out, OOP models the entries. Change the colors, add a
new log level, add another entry type.