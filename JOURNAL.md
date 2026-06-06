# Journal — `r_nim_practice`

> Final snapshot: 2026-06-07. Nim 2.2.6.

## Structure

```
r_nim_practice/
├── 01_basics/ ... 10_concurrency/    ← 10-group curriculum (concept → exercises → project)
├── reference/                          ← FFI calling + exporting
├── apps/                               ← 4 standalone CLI tools
│   ├── fortune/      (quote picker)
│   ├── journal/      (fzf activity log)
│   ├── nim_nuggets/  (snippet refresher)
│   └── todo/         (full CLI manager)
├── README.md
├── REFERENCES.md
└── JOURNAL.md
```

## Overview

**75 `.nim` files** across 10 progressive groups + 4 standalone apps + 2 FFI reference files.
Total: 3,752 lines of Nim code.

## Apps — standalone tools

### `apps/todo/` (458 lines)
The feature flagship. Enums for Priority and Category. JSON persistence. `at` scheduling
with mpv + notify-send. Environment variable forwarding (DISPLAY, DBUS, PULSE).
Shell-safe quoting throughout. Recovered from git history after being lost to deletion.

### `apps/journal/` (280 lines)
Full CLI activity journal. fzf integration for browsing/searching entries.
Colored panels (╭╮╰╯ borders). JSON persistence with atomic writes (`.tmp` → move).
EDITOR integration for composing entries. Recovered from commit `145d84f`.

### `apps/nim_nuggets/` (418 lines)
Spaced repetition snippet refresher. fzf topic browsing with symlink-based
active topic. Cross-topic search. Weekly rotation reminder. 8 topic files
with Nim-specific snippets (os, strutils, tables, terminal, times, sequences,
set, code). Recovered from commit `b509c73`.

### `apps/fortune/` (32 lines)
Fortune-like random quote picker. Reads `Computer_Quotes.txt` via `sample()`
from `std/random`. Minimal, single-purpose. Recovered from commit `1e18a77`.

## Curriculum — what each group covers

| # | Group | Concept files | Exercises | Project | What you learn |
|---|---|---|---|---|---|
| 01 | Basics | 3 | 2 | `todo.nim` | Compilation, types, input, CLI args |
| 02 | Control Flow | 3 | 3 | `unitconv.nim` | if/case, for/while, iterators |
| 03 | Procedures | 4 | 3 | `filesize.nim` | proc, result, UFCS, templates, time |
| 04 | Sequences | 3 | 4 | `stats.nim` | seq[T], slicing, sequtils, enums, tuples |
| 05 | Strings | 4 | 3 | `password.nim` | strutils, format, parsing, regex |
| 06 | Collections | 3 | 3 | `counter.nim` | Table, HashSet, CountTable |
| 07 | Filesystem | 2 | 3 | `usb_mounter.nim` | Files, dirs, walkDir, FFI |
| 08 | Error Handling | 2 | 3 | `fallback.nim` | try/except, Option[T], fallbacks |
| 09 | Type System | 4 | 3 | `banking.nim` | Distinct types, variants, compile-time, memory |
| 10 | Concurrency | 3 | 1 | `downloader.nim` | Async, threads, process pipes |

## Top 10 files by size

| Lines | File | What |
|--------|------|------|
| 458 | `apps/todo/todo.nim` | Full CLI w/ enums, JSON persistence, at scheduling, sound |
| 418 | `apps/nim_nuggets/nim_nuggets.nim` | Snippet refresher with fzf, search, weekly reminders |
| 350 | `07_filesystem/project/usb_mounter.nim` | Interactive TUI, mount/unmount USB, filesystem detection |
| 302 | `07_filesystem/project/usb_tui.nim` | Companion TUI for USB mounter |
| 280 | `apps/journal/nim_journal.nim` | Activity journal: add/search/delete via fzf |
| 208 | `09_type_system/project/banking.nim` | Banking app: ref objects, SHA1 auth, in-memory DB |
| 170 | `05_strings/project/password.nim` | Password gen/manager: clipboard, urandom, chmod 0600 |
| 115 | `06_collections/concept/tables.nim` | Hash maps, ordered maps, counters |
| 105 | `05_strings/concept/strutils.nim` | String manipulation tour |
| 101 | `10_concurrency/concept/threads.nim` | Thread pool, channels, file processing |

## Concept highlights

### Type system (09)
- `variants.nim` — Variant objects (sum types). Exhaustive `case` checks. Compile-time safe.
- `distinct.nim` — Distinct types prevent mixing meters/feet. Zero runtime cost.
- `compiletime.nim` — Nim's superpower: `static`, `const`, `when` — compile-time computation.
- `memory.nim` — ARC/ORC memory models. `--mm:arc` compilation flag.

### Concurrency (10)
- `async.nim` — `{.async.}` pragma rewrites procs into state machines. `asyncdispatch` event loop.
- `threads.nim` — `spawn()` with thread pool. `Channel[T]` for message passing. `sync()` barrier.
- `pipes.nim` — Process pipes (`startProcess`, `inputStream`, `outputStream`).

### FFI (reference/)
- `ffi_calling.nim` — Zero-cost C interop. `{.importc, header.}` declares C functions directly.
- `ffi_exporting.nim` — Export Nim code as `.so` callable from C/Python.

## Numbers

| Category | Count |
|----------|-------|
| Total `.nim` files | 75 |
| Concept files | 34 |
| Exercise files | 28 |
| Curriculum project files | 11 |
| Standalone app files | 4 |
| Reference files | 2 |
| Data files | 10 (journal.json + 8 nugget topics + quotes) |
| README.md files | 12 |
| Makefile files | 10 |
| Total code lines | 3,752 |
| Max single file | 458 lines (`apps/todo/todo.nim`) |
| Smallest concept | 13 lines (`01_basics/concept/hello.nim`) |
| Groups with 3+ exercises | 8 of 10 |
