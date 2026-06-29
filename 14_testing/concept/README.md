# 14 Testing — Automated Tests with std/unittest

## Quick Start

```bash
nim c -r 14_testing/concept/why_test.nim
nim c -r 14_testing/concept/suites.nim
nim c -r 14_testing/concept/assertions.nim
nim c -r 14_testing/concept/fixtures.nim
nim c -r 14_testing/concept/testing_cli.nim
```

For a multi-file testing demo (import tests from separate files):
```bash
nim c -r 14_testing/concept/organize/runtests.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `why_test.nim` | Motivation: why automated testing | Echo-checking fails silently; `check` from unittest reports clearly |
| `suites.nim` | suite/test/check three-level structure | Suite = unit; test = behavior; check = one expectation; naming conventions |
| `assertions.nim` | check vs require vs expect vs assert | check continues; require aborts; expect catches; assert crashes (use in production code) |
| `fixtures.nim` | setup/teardown for resource management | setup runs before each test; teardown runs after (even on failure); mutable state gotcha |
| `testing_cli.nim` | Testing CLI logic via pure procs | Extract pure procs from main; test those; CLI just orchestrates |
| `test_it.nim` | Challenge: combine all concepts | Boundary edges, expect, check — full suite for gradeFromScore |

## organize/ — Multi-File Testing Demo

The `organize/` directory shows a realistic project structure with separate test files:

| File | Role |
|------|------|
| `mymath.nim` | Pure math module (add, subtract, multiply) |
| `myformat.nim` | String formatting (padCenter, truncateLeft) |
| `mymain.nim` | Orchestrator that imports both, exports processInput + formatOutput |
| `test_mymath.nim` | Unit tests for mymath |
| `test_myformat.nim` | Unit tests for myformat |
| `test_mymain.nim` | Integration tests for mymain |
| `runtests.nim` | Imports all test files, runs every suite |

Run: `nim c -r 14_testing/concept/organize/runtests.nim`

## Common Patterns

```nim
import std/unittest

proc add(a, b: int): int = a + b

suite "math":
  test "addition":
    check add(2, 2) == 4
    check add(-1, 1) == 0

  test "properties":
    check add(0, 0) == 0
```

With setup/teardown:

```nim
import std/unittest, std/os

suite "file ops":
  var path: string

  setup:
    path = getTempDir() / "test.txt"
    writeFile(path, "hello")

  teardown:
    if fileExists(path):
      removeFile(path)

  test "reads file":
    check readFile(path) == "hello"
```

## Test it

Run `test_it.nim` — it implements a full `gradeFromScore` test suite with
boundary edges (89→B, 90→A, 59→F, 60→D), `expect` for invalid inputs
(negative score, score > max), and non-100 maxScore cases. All passing —
use it as a model for your own suites.
