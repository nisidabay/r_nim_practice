# Journal — `r_nim_practice`

> Updated: 2026-06-24. Nim 2.2.6. 13 groups + 7 standalone apps.

## Structure

```
r_nim_practice/
├── 01_basics/ ... 13_niche_modules/    ← 13-group curriculum (concept → exercises → project)
├── apps/                                 ← 7 standalone CLI tools
│   ├── fortune/        (quote picker)
│   ├── journal/        (fzf activity log)
│   ├── nim_nuggets/    (snippet refresher)
│   ├── password/       (password generator/manager)
│   ├── todo/           (full CLI manager)
│   └── usb_mounter/    (USB mounter + TUI)
├── README.md
├── REFERENCES.md
└── JOURNAL.md
```

## Overview

**13 progressive groups** covering Nim from zero to real tools. Each group has concept files, exercises, and a project that ONLY uses concepts taught up to that point. Advanced projects live in `apps/` as standalone tools.

## Curriculum — what each group covers

| # | Group | Concept files | Exercises | Project | What you learn |
|---|---|---|---|---|---|
| 01 | Basics | 3 | 2 | `greeting.nim` | Compilation, types, input, CLI args |
| 02 | Control Flow | 3 | 3 | `unitconv.nim` | if/case, for/while, iterators |
| 03 | Procedures | 4 | 3 | `filesize.nim` | proc, result, UFCS, templates, time |
| 04 | Sequences | 3 | 4 | `stats.nim` | seq[T], slicing, sequtils, enums, tuples |
| 05 | Strings | 4 | 3 | `csv_parser.nim` | strutils, format, parsing, regex |
| 06 | Collections | 3 | 3 | `counter.nim` | Table, HashSet, CountTable |
| 07 | Filesystem | 2 | 3 | `tree.nim` | Files, dirs, walkDir |
| 08 | Error Handling | 2 | 3 | `fallback.nim` | try/except, Option[T], fallbacks |
| 09 | Type System | 3 | 3 | `banking.nim` | Distinct types, variants, compile-time |
| 10 | Concurrency | 3 | 1 | `parallel_downloader.nim` | Async, threads, process pipes |
| 11 | Stdlib Essentials | 6 | 3 | `sysinfo.nim` | Math, OS, JSON, Algorithm, Modules, Arrays |
| 12 | Ecosystem & Tooling | 8 | 3 | `log_analyzer.nim` | Terminal, logging, parsecfg, parsecsv, URI, pragmas, Nimble, OOP |
| 13 | Niche Modules | 3 | 1 | `data_analyzer.nim` | stats, colors, sugar, lenientops, enumutils |

## Apps — standalone tools (use concepts from multiple groups)

### `apps/todo/` (458 lines)
Full CLI todo manager. Enums for Priority and Category. JSON persistence. `at` scheduling
with mpv + notify-send. Environment variable forwarding. Shell-safe quoting.

### `apps/nim_nuggets/` (418 lines)
Spaced repetition snippet refresher. fzf topic browsing with symlink-based
active topic. Cross-topic search. Weekly rotation reminder. 8 topic files.

### `apps/usb_mounter/` (652 lines total)
USB device mounter (`usb_mounter.nim` 350 lines) with interactive TUI frontend
(`usb_tui.nim` 302 lines). Mount/unmount, filesystem detection, ncurses interface.

### `apps/journal/` (280 lines)
Activity journal. fzf integration for browsing/searching. Colored panels.
JSON persistence with atomic writes. EDITOR integration.

### `apps/password/` (171 lines)
Password generator/manager. `/dev/urandom` entropy, clipboard support,
`chmod 0600` permissions, 4 complexity levels.

### `apps/fortune/` (32 lines)
Fortune-like random quote picker. Reads `Computer_Quotes.txt` via `sample()`
from `std/random`. Minimal, single-purpose.

## Concept highlights

### Type system (09)
- `variants.nim` — Variant objects (sum types). Exhaustive `case` checks. Compile-time safe.
- `distinct.nim` — Distinct types prevent mixing meters/feet. Zero runtime cost.
- `compiletime.nim` — Compile-time execution: `const` and `when`. Zero-cost abstractions.

### Concurrency (10)
- `async.nim` — `{.async.}` pragma rewrites procs into state machines. `asyncdispatch` event loop.
- `threads.nim` — `spawn()` with thread pool. `Channel[T]` for message passing. `sync()` barrier.
- `pipes.nim` — Process pipes (`startProcess`, `inputStream`, `outputStream`).


## Design principle

Each group's project is a **natural culmination** of only what's been taught up to that point.
Advanced projects that use concepts from future groups live in `apps/` as standalone tools.
This keeps the learning path progressive — no jumping from "hello world" to a 458-line todo manager.

## Restructuring (2026-06-12)

Moved 4 mismatched projects to `apps/` and created 4 replacement projects:
- G01: `todo.nim` → `apps/todo/` (already there), replaced with `greeting.nim`
- G05: `password.nim` → `apps/password/`, replaced with `csv_parser.nim`
- G07: `usb_mounter.nim` + `usb_tui.nim` → `apps/usb_mounter/`, replaced with `tree.nim`
- G10: `downloader.nim` (sequential) → replaced with `parallel_downloader.nim` (actual concurrency)
