# Nim — From Zero to Real Tools

A progressive, code-first curriculum for learning Nim through CLI scripting
and systems programming. No frameworks, no heavy dependencies — just the
standard library and real problems.

## Who This Is For

- You program in Python, Ruby, or Go and want a fast compiled language
- You write Bash scripts and want something more maintainable and portable
- You're curious about a language that compiles to C with zero overhead

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
`08_error_handling` → `09_type_system` → `10_concurrency`.

## The Toolbox

`projects/` contains real CLI tools built with the concepts above.
Everything here was built to solve an actual problem on a Linux machine.

| Project | What it does | Nim features used |
|---|---|---|
| `banking_app/` | Terminal banking interface | Objects, error handling, terminal UI |
| `password_project/` | Password generator/manager | Random, strutils, CLI args |
| `usb_mounter/` | USB device mounter with TUI | Processes, os, error handling |

## Running a File

```bash
# Standard compile + run
nim c -r 01_basics/concept/hello.nim

# Optimized (release mode)
nim c -d:release -r 01_basics/concept/hello.nim

# With threads (required for concurrency)
nim c -r --threads:on 10_concurrency/concept/async.nim

# With specific memory model
nim c --mm:arc -r 09_type_system/concept/memory.nim
```

## Group Overview

| # | Group | Concept files | Exercises | What you learn |
|---|---|---|---|---|
| 01 | Basics | 3 | 2 | Compilation, types, input, CLI args |
| 02 | Control Flow | 3 | 3 | if/case, for/while, iterators |
| 03 | Procedures | 4 | 3 | proc, result, UFCS, templates, time |
| 04 | Sequences | 3 | 4 | seq[T], slicing, sequtils, enums, tuples |
| 05 | Strings | 4 | 3 | strutils, format, parsing, regex |
| 06 | Collections | 3 | 3 | Table, HashSet, CountTable |
| 07 | Filesystem | 4 | 3 | Files, dirs, walkDir, FFI |
| 08 | Error Handling | 2 | 3 | try/except, Option[T], fallbacks |
| 09 | Type System | 4 | 3 | Distinct types, variants, compile-time, memory |
| 10 | Concurrency | 3 | 1 | Async, threads, process pipes |

## References

See [`REFERENCES.md`](REFERENCES.md) for books, official docs, and community resources.
