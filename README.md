# Nim — From Zero to Real Tools

A progressive, code-first curriculum for learning Nim through CLI scripting and task automation. No frameworks, no heavy dependencies — just the standard library and real problems.

## Who This Is For

- You program in Python, Ruby, or Go and want a fast compiled language
- You write Bash scripts and want something more maintainable and portable
- You're curious about a language that compiles to C with zero overhead

## Installation

```bash
# Arch Linux (package in official repos)
sudo pacman -S nim nimble

# Any distro — choosenim (official version manager)
# curl -sS https://nim-lang.org/choosenim/init.sh | sh

# macOS
# brew install nim

# Verify
nim --version
```

Nim 2.2.6+. No runtime needed, no interpreter needed — compiles to native binary.

## Getting Started

```bash
# One command to check Nim is installed (2.2.6+)
nim --version

# Compile and run any concept file
nim c -r 01_basics/concept/hello.nim
```

## Two Paths In

### Path A: The Sampler (~20 min)

Read the concept READMEs. Each group ends with **Pónlo a prueba** — una
invitación a practicar sin presión. Coge el código, modifícalo, rompe algo:

```bash
cat 01_basics/concept/README.md     # → combina hello.nim + input.nim
cat 05_strings/concept/README.md    # → parte un CSV con split()
cat 09_type_system/concept/README.md   # → prueba tipos distinct
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

Then keep going: `01_basics` → `02_control_flow` → `03_procedures` → `04_sequences` → `05_strings` → `06_collections` → `07_filesystem` → `08_error_handling` → `09_type_system` → `10_concurrency` → `11_stdlib` → `12_ecosystem_tooling` → `13_niche_modules`.

## The Toolbox

Each group has a `project/` directory with a real CLI tool built from that group's concepts. Everything here solves an actual problem on a Linux machine.

| Group | Project | What it does |
|---|---|---|
| 01 | `greeting.nim` | CLI greeting that prints your age from birth year |
| 02 | `unitconv.nim` | Unit converter — km/miles, kg/lbs, °C/°F |
| 03 | `filesize.nim` | CLI calculator — sum, rest, mul, div, potencias |
| 04 | `stats.nim` | Statistics calculator — mean, median, min, max |
| 05 | `csv_parser.nim` | CSV line parser — stdin, split, tabla alineada |
| 07 | `tree.nim`, `counter.nim`, `file_stats.nim` | Directory tree viewer + word frequency counter + line/word/char stats |
| 08 | `fallback.nim` | URL fetcher with fallback chain — try until one works |
| 09 | `banking.nim` | Terminal banking app with ref objects and accounts |
| 10 | `parallel_downloader.nim` | Multi-file HTTP downloader with concurrent threads |
| 11 | `sysinfo.nim` | JSON-config-driven system info reporter — OS, CPU, math stats |
| 12 | `log_analyzer.nim` | Log analyzer — CSV logs with colored severity levels, config-driven themes |
| 13 | `data_analyzer.nim` | Text file stats — reads numbers, computes stats, color report (legacy) |

## Running a File

```bash
# Standard compile + run
nim c -r 01_basics/concept/hello.nim

# Optimized (release mode)
nim c -d:release -r 01_basics/concept/hello.nim

# With threads (required for concurrency)
nim c -r --threads:on 10_concurrency/concept/async.nim

# Run tests (see 08_error_handling/concept/testing.nim for unittest)
make test
```

## Group Overview

| # | Group | Concept files | Exercises | What you learn |
|---|---|---|---|---|---|
| 01 | Basics | 3 | 2 | Compilation, types, input, CLI args |
| 02 | Control Flow | 3 | 3 | if/case, for/while, iterators |
| 03 | Procedures | 3 | 3 | proc, func, result, UFCS, templates, varargs, discard |
| 04 | Sequences | 3 | 4 | seq[T], array[N,T], openArray, slices, sequtils |
| 05 | Strings | 4 | 2 | strutils, format, parsing, regex |
| 06 | Collections | 2 | 4 | Table, HashSet, bit sets, CountTable |
| 07 | Filesystem | 3 | 3 | File I/O, dir traversal, process pipes, env vars, debugging |
| 08 | Error Handling | 3 | 3 | try/except, Option[T], fallbacks, unittest, defer |
| 09 | Type System | 6 | 3 | Distinct types, variants, enums, tuples, OOP, generics, compile-time |
| 10 | Concurrency | 2 | 1 | Async, threads |
| 11 | Stdlib Essentials | 10 | 3 | JSON, Algorithm, Modules, Random, Stats, Times, Math, URI, ParseOpt, HTTP |
| 12 | Ecosystem & Tooling | 5 | 3 | Logging, parsecfg, parsecsv, pragmas, Nimble, performance |
| 13 | Niche Modules | 0 | 1 | exercises and project only (legacy) |

## Scripts

Single-file tools that replace Bash scripts — focused, under 60 lines, CLI args only.

| Script | What it does | Concepts used |
|--------|-------------|---------------|
| `bulk_rename.nim` | Rename files by regex pattern in any directory | `walkDir`, `moveFile`, `strutils.replace` |
| `log_tail.nim` | Read a log file, filter by severity, print summary | `readFile`, `splitLines`, `CountTable` |
| `disk_usage.nim` | Walk a directory tree, compute total size, show largest file | `walkDirRec`, `getFileSize`, formatting |
| `fortune/quotes.nim` | Random quote picker from a text file | `readFile`, `split`, `sample`, `strip` |

```bash
nim c -r scripts/bulk_rename.nim ".tmp$" ".backup" ~/Downloads
nim c -r scripts/log_tail.nim /var/log/syslog ERROR
nim c -r scripts/disk_usage.nim ~/projects
nim c -r scripts/fortune/quotes.nim
```

## Apps

Multi-file or complex interactive tools — menus, TUI, configuration, persistent storage.

| App | Description |
|---|---|
| `apps/journal/` | Activity journal — add, search, delete entries via fzf, JSON storage, colored panels |
| `apps/nim_nuggets/` | Spaced-repetition snippet refresher — fzf browsing, cross-topic search, 8 topic files |
| `apps/password/` | Password generator/manager with clipboard support and complexity options |
| `apps/todo/` | Full CLI todo manager — enums, JSON persistence, `at` scheduling with sound |
| `apps/usb_mounter/` | USB device mounter with interactive TUI (usb_mounter.nim + usb_tui.nim) |

### Script vs App — The Rule

```
Script  → single file, ≤ 60 lines, no interactivity, replaces a Bash one-liner
App     → multi-file or > 60 lines, interactive (menus/TUI), persistent state, real tool
```

## References

See [`REFERENCES.md`](REFERENCES.md) for books, official docs, and community resources.

