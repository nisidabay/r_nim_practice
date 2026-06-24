# Nim — From Zero to Real Tools

A progressive, code-first curriculum for learning Nim through CLI scripting
and task automation. No frameworks, no heavy dependencies — just the
standard library and real problems.

## Who This Is For

- You program in Python, Ruby, or Go and want a fast compiled language
- You write Bash scripts and want something more maintainable and portable
- You're curious about a language that compiles to C with zero overhead

## Installation

```bash
# Arch Linux (package en repos oficiales)
sudo pacman -S nim nimble

# Cualquier distro — choosenim (version manager oficial)
# curl -sS https://nim-lang.org/choosenim/init.sh | sh

# macOS
# brew install nim

# Verificar
nim --version
```

Nim 2.2.6+. No necesitás runtime, no necesitás intérprete — compila a binario nativo.

## Getting Started

```bash
# One command to check Nim is installed (2.2.6+)
nim --version

# Compile and run any concept file
nim c -r 01_basics/concept/hello.nim
```

## Two Paths In

### Path A: The Sampler (~20 min)

Read the concept READMEs. Each group has a **Now Build Your Own** challenge
at the bottom. Pick one that interests you and build it:

```bash
cat 01_basics/concept/README.md     # → "Write a greeting program"
cat 05_strings/concept/README.md    # → "Write a CSV parser"
cat 09_type_system/concept/README.md   # → "Celsius ↔ Fahrenheit distinct types"
```

### Path B: Systematic (~several weeks)

Work through the numbered groups in order. Each has:

- **concept/README.md** — quick-start table + learning path
- **concept/*.nim** — one concept per file, code-first, runnable standalone
- **exercises/** — 3 solved practice problems + Makefile
- **project/** — a real CLI tool using the group's concepts

```bash
cd 01_basics/concept
cat README.md                   # see the map
nim c -r hello.nim              # first concept
```

Then keep going: `01_basics` → `02_control_flow` → `03_procedures` →
`04_sequences` → `05_strings` → `06_collections` → `07_filesystem` →
`08_error_handling` → `09_type_system` → `10_concurrency` → `11_stdlib` → `12_ecosystem_tooling` → `13_niche_modules`.

## The Toolbox

Each group has a `project/` directory with a real CLI tool built from that
group's concepts. Everything here solves an actual problem on a Linux machine.

| Group | Project | What it does |
|---|---|---|
| 01 | `greeting.nim` | CLI greeting that prints your age from birth year |
| 02 | `unitconv.nim` | Unit converter — km/miles, kg/lbs, °C/°F |
| 03 | `filesize.nim` | Disk usage like `du -sh` for any path |
| 04 | `stats.nim` | Statistics calculator — mean, median, min, max |
| 05 | `csv_parser.nim` | CSV file reader — splits lines, trims fields, aligns columns |
| 06 | `counter.nim` | Word frequency counter — top 10 from any file |
| 07 | `tree.nim` | Directory tree viewer — recursive walk with indented output |
| 08 | `fallback.nim` | URL fetcher with fallback chain — try until one works |
| 09 | `banking.nim` | Terminal banking app with ref objects and accounts |
| 10 | `parallel_downloader.nim` | Multi-file HTTP downloader with concurrent threads |
| 11 | `sysinfo.nim` | JSON-config-driven system info reporter — OS, CPU, math stats |
| 12 | `log_analyzer.nim` | Log analyzer — CSV logs with colored severity levels, config-driven themes |
| 13 | `data_analyzer.nim` | Text file stats — reads numbers, computes stats, color report |

## Running a File

```bash
# Standard compile + run
nim c -r 01_basics/concept/hello.nim

# Optimized (release mode)
nim c -d:release -r 01_basics/concept/hello.nim

# With threads (required for concurrency)
nim c -r --threads:on 10_concurrency/concept/async.nim
```

## Group Overview

| # | Group | Concept files | Exercises | What you learn |
|---|---|---|---|---|
| 01 | Basics | 3 | 2 | Compilation, types, input, CLI args |
| 02 | Control Flow | 3 | 3 | if/case, for/while, iterators |
| 03 | Procedures | 4 | 3 | proc, result, UFCS, time |
| 04 | Sequences | 3 | 4 | seq[T], slicing, sequtils, enums, tuples |
| 05 | Strings | 4 | 3 | strutils, format, parsing, regex |
| 06 | Collections | 3 | 3 | Table, HashSet, CountTable |
| 07 | Filesystem | 2 | 3 | Files, dirs, walkDir |
| 08 | Error Handling | 2 | 3 | try/except, Option[T], fallbacks |
| 09 | Type System | 3 | 3 | Distinct types, variants, compile-time |
| 10 | Concurrency | 3 | 1 | Async, threads, process pipes |
| 11 | Stdlib Essentials | 6 | 3 | Math, OS, JSON, Algorithm, Modules, Arrays |
| 12 | Ecosystem & Tooling | 8 | 3 | Terminal, logging, parsecfg, parsecsv, URI, pragmas, Nimble, OOP |
| 13 | Niche Modules | 3 | 1 | stats, colors, sugar, lenientops, enumutils |

## Scripts

Three real-world scripts showing how Nim replaces Bash for common tasks:

| Script | What it does | Concepts used |
|--------|-------------|---------------|
| `bulk_rename.nim` | Rename files by regex pattern in any directory | `walkDir`, `moveFile`, `strutils.replace` |
| `log_tail.nim` | Read a log file, filter by severity, print summary | `readFile`, `splitLines`, `CountTable` |
| `disk_usage.nim` | Walk a directory tree, compute total size, show largest file | `walkDirRec`, `getFileSize`, formatting |

```bash
nim c -r scripts/bulk_rename.nim ".tmp$" ".backup" ~/Downloads
nim c -r scripts/log_tail.nim /var/log/syslog ERROR
nim c -r scripts/disk_usage.nim ~/projects
```

## Apps

Standalone Nim CLI tools — real programs, not exercises.

| App | Description |
|---|---|---|
| `apps/fortune/` | Fortune-like random quote picker — reads `Computer_Quotes.txt`, picks one via `randomize()` |
| `apps/journal/` | Activity journal — add, search, delete entries via fzf, JSON storage, colored panels |
| `apps/nim_nuggets/` | Spaced-repetition snippet refresher — fzf browsing, cross-topic search, 8 topic files |
| `apps/password/` | Password generator/manager with clipboard support and complexity options |
| `apps/todo/` | Full CLI todo manager — enums, JSON persistence, `at` scheduling with sound |
| `apps/usb_mounter/` | USB device mounter with interactive TUI (usb_mounter.nim + usb_tui.nim) |

## References

See [`REFERENCES.md`](REFERENCES.md) for books, official docs, and community resources.
