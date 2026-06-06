# Journal — `r_nim_practice`

> Final snapshot: 2026-06-07. Nim 2.2.6.

## Overview

**75 `.nim` files** across 10 progressive groups (basics → concurrency), plus
**4 standalone projects** recovered from git history, **2 FFI reference files**,
and **1 companion data file** (quotes). Total: 3,752 lines of Nim code.

```
01_basics           → 3 concept + 2 exercises + 1 project
02_control_flow     → 3 concept + 3 exercises + 1 project
03_procedures       → 4 concept + 3 exercises + 1 project
04_sequences        → 3 concept + 4 exercises + 1 project
05_strings          → 4 concept + 3 exercises + 2 projects
06_collections      → 3 concept + 3 exercises + 1 project
07_filesystem       → 2 concept + 3 exercises + 2 projects
08_error_handling   → 2 concept + 3 exercises + 1 project
09_type_system      → 4 concept + 3 exercises + 2 projects
10_concurrency      → 3 concept + 1 exercise  + 1 project
fortune/            → 1 nim + 1 data file (quotes)
journal/            → 1 nim + 1 json (activity log)
nim_nuggets/        → 1 nim + 8 topic files (snippet refresher)
reference/          → 2 FFI reference files (call C, export to C)
```

## Standalone projects (recovered from git history)

### `fortune/quotes.nim` (32 lines)
Fortune-like random quote picker. Reads `Computer_Quotes.txt` via `sample()`
from `std/random`. Minimal, single-purpose. Recovered from commit `1e18a77`.

### `journal/nim_journal.nim` (280 lines)
Full CLI activity journal. fzf integration for browsing/searching entries.
Colored panels (╭╮╰╯ borders). JSON persistence with atomic writes (`.tmp` →
move). EDITOR integration for composing entries. Recovered from commit `145d84f`.

### `nim_nuggets/nim_nuggets.nim` (418 lines)
Spaced repetition snippet refresher. fzf topic browsing with symlink-based
active topic. Cross-topic search. Weekly rotation reminder. 8 topic files
with Nim-specific snippets (os, strutils, tables, terminal, times, sequences,
set, code). Recovered from commit `b509c73`.

## Top 10 files by size

| Lines | File | What |
|--------|------|------|
| 458 | `01_basics/project/todo.nim` | Full CLI w/ enums, JSON persistence, at scheduling, sound |
| 418 | `nim_nuggets/nim_nuggets.nim` | Snippet refresher with fzf, search, weekly reminders |
| 350 | `07_filesystem/project/usb_mounter.nim` | Interactive TUI, mount/unmount USB, filesystem detection |
| 302 | `07_filesystem/project/usb_tui.nim` | Companion TUI for USB mounter |
| 280 | `journal/nim_journal.nim` | Activity journal: add/search/delete via fzf |
| 208 | `09_type_system/project/banking.nim` | Banking app: ref objects, SHA1 auth, in-memory DB |
| 170 | `05_strings/project/password.nim` | Password gen/manager: clipboard, urandom, chmod 0600 |
| 115 | `06_collections/concept/tables.nim` | Hash maps, ordered maps, counters |
| 105 | `05_strings/concept/strutils.nim` | String manipulation tour |
| 101 | `10_concurrency/concept/threads.nim` | Thread pool, channels, file processing |

## Project toolkit — real CLI tools

Every group ships a working tool:

### 01 — `todo.nim` (458 lines)
Enums for Priority and Category. JSON persistence. `at` scheduling with mpv + notify-send.
Environment variable forwarding (DISPLAY, DBUS, PULSE). Shell-safe quoting throughout.
The feature flagship — recovered from git history after being lost to deletion.

### 07 — `usb_mounter.nim` (350 lines)
Requires root — uses `getEuid()` check. Filesystem detection via `blkid`. NTFS/exFAT/ext4
troubleshooting hints. Interactive TUI menu (mount/unmount/list). Labeled USB mounting.
Real systems programming — not a toy.

### 09 — `banking.nim` (208 lines)
`ref object` types (passed by reference). In-memory DB as `seq[User]`. Password hashing
via `std/sha1`. Deposit/withdraw/transfer operations. Companion `mask_entry.nim` for
password input masking. Demonstrates type-safe mutable state without a database.

### 05 — `password.nim` (170 lines)
`std/sysrand` for cryptographic randomness. Enum-driven complexity (weak→very_strong).
Clipboard read via xclip/xsel/wl-paste chain (Wayland/X11 compatible). Hidden input
via `readPasswordFromStdin()`. Files saved to `~/Documents/Passwords/` with `chmod 0600`.
`parseopt` for CLI flags (`-l:32 -c:very_strong github`). Production-quality tool.

## Concept files that teach well

### Type system (09)
- `variants.nim` — Variant objects (sum types). Exhaustive `case` checks. Shared fields. Compile-time safe.
- `distinct.nim` — Distinct types prevent mixing meters/feet. Zero runtime cost.
- `compiletime.nim` — Nim's superpower: `static`, `const`, `when` — compile-time computation.
- `memory.nim` — ARC/ORC memory models. `--mm:arc` compilation flag.

### Concurrency (10)
- `async.nim` — `{.async.}` pragma rewrites procs into state machines. `asyncdispatch` event loop. Same model as Node.js/asyncio/Go.
- `threads.nim` — `spawn()` with thread pool. `Channel[T]` for message passing. `sync()` barrier. No mutexes.
- `pipes.nim` — Process pipes (`startProcess`, `inputStream`, `outputStream`).

### FFI (reference/)
- `ffi_calling.nim` — Zero-cost C interop. `{.importc, header.}` declares C functions directly. No bindings needed.
- `ffi_exporting.nim` — Export Nim code as `.so` callable from C/Python.

## Coverage gaps noticed

### Thin areas
- **01_basics**: Only 3 concept files (hello, types, input). Missing: CLI args, compilation flags deep dive.
- **01_basics/exercises**: Only 2 exercises (greeting, temperature). Should have 3-4.
- **10_concurrency/exercises**: Only 1 exercise (`prime_parallel.nim`). Should have 3.
- **10_concurrency/concept**: Missing `asyncfile`, `asyncnet` advanced patterns.
- **07_filesystem/concept**: Only 2 files (`files.nim`, `walk_files.nim`). Missing: `tempfiles`, `memfiles`, `streams`.

### Missing entirely
- Macros practical examples (in a tutorial, not reference style)
- NimScript (run nim files as scripts without compilation)
- `compiler/` module introspection
- GUI basics (if not covered elsewhere)

## Nim-specific patterns observed

1. **`{.async.}` pragma** — Rewrites sync proc into coroutine state machine. Every `await` = suspension point.
2. **`{.importc, header.}`** — Zero-cost FFI. Nim *is* a C compiler. Direct calls, no marshalling.
3. **Variant objects** — Tagged unions. Exhaustive `case` enforced at compile time. Wrong field access = compile error.
4. **`ref object` vs `object`** — ref = heap-allocated, reference semantics. object = value semantics, stack-allocated.
5. **`const` vs `let` vs `var`** — const = compile-time. let = runtime immutable. var = mutable. Clean distinction.
6. **`std/sysrand`** — Cryptographic randomness via OS (`getrandom` on Linux, `arc4random` on macOS/BSD).
7. **Thread safety** — `Channel[T]` for message passing. `spawn()` uses thread pool automatically. No manual mutex management.

## Git history notes

- Originally `r_nim_projects` → renamed to `r_nim_practice`.
- Commits from Nov 2025 through Jun 2026.
- **Recovered from git history:** `todo.nim` (enum-based), `nim_journal`, `nim_nuggets`, `fortune`.
- `andreas/` content (book examples) was present pre-restructure, not in current tree.
- `reference/` tours were redistributed into concept/ files per group.

## Numbers

| Category | Count |
|----------|-------|
| Total `.nim` files | 75 |
| Concept files | 34 |
| Exercise files | 28 |
| Project files (groups) | 11 |
| Standalone projects | 3 |
| Reference files | 2 |
| Data files | 9 (journal.json + 8 nugget topics + quotes) |
| README.md files | 12 |
| Makefile files | 10 |
| Total code lines | 3,752 |
| Max single file | 458 lines (`todo.nim`) |
| Smallest concept | 13 lines (`01_basics/concept/hello.nim`) |
| Groups with 3+ exercises | 8 of 10 |
