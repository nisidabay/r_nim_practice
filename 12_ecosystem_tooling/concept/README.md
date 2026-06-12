# 12 Ecosystem & Tooling — Stdlib Modules, Pragmas, Nimble, OOP

## Quick Start

```bash
nim c -r 12_ecosystem_tooling/concept/terminal.nim
nim c -r 12_ecosystem_tooling/concept/logging.nim
nim c -r 12_ecosystem_tooling/concept/parsecfg.nim
nim c -r 12_ecosystem_tooling/concept/parsecsv.nim
nim c -r 12_ecosystem_tooling/concept/uri.nim
nim c -r 12_ecosystem_tooling/concept/pragmas.nim
nim c -r 12_ecosystem_tooling/concept/oop.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `terminal.nim` | ANSI colors, cursor control, dimensions | `setForegroundColor`, `terminalWidth`, `cursorUp` |
| `logging.nim` | Structured logging with levels and handlers | `newConsoleLogger`, `addHandler`, `info`/`warn`/`error` |
| `parsecfg.nim` | INI-style config file parsing | `loadConfig`, `getSectionValue`, `sections` |
| `parsecsv.nim` | CSV file parsing with header support | `CsvParser`, `open`/`readRow`/`close`, `row["header"]` |
| `uri.nim` | URL parsing, encoding, reconstruction | `parseUri`, `encodeQuery`/`decodeQuery`, `$url` |
| `pragmas.nim` | Compiler directives and optimization | `{.inline.}`, `{.compileTime.}`, `{.used.}` |
| `nimble.nim` | Nimble packaging format reference | `.nimble` fields, `require`, `bin`, `task` |
| `oop.nim` | Ref objects, inheritance, method dispatch | `ref object`, `of` inheritance, `method` vs `proc` |

## Common Patterns

```nim
import std/[terminal, logging, parsecfg, parsecsv, uri]

# Terminal colors
setForegroundColor(fgRed); echo "Error"; resetAttributes()

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

# URL parsing
let u = parseUri("https://nim-lang.org/docs")
echo u.hostname

# OOP: method dispatch
method speak(a: Animal): string {.base.}
method speak(d: Dog): string = "Woof!"
```

## Now Build Your Own

Write a CLI tool that reads a config file with `[theme]` settings (foreground
and background colors), parses a CSV of server status entries, and renders a
colored status board using terminal codes with structured logging for
operational messages. Each severity level gets its own color — errors in red,
warnings in yellow, success in green. Use OOP to model different log entry
types with their own format methods.