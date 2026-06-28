# 08 Error Handling — Exceptions and Option Types

## Quick Start

```bash
nim c -r 08_error_handling/concept/try_except.nim
nim c -r 08_error_handling/concept/option.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `try_except.nim` | try/except/finally, raise, custom exceptions, defer | Multiple except branches, `as e` binding; `defer` runs on scope exit (even on exception) |
| `option.nim` | Option[T]: some/none pattern | Chain with `?.` or `get/unsafeGet` — no nil checks |

## Common Patterns

```nim
try:
  let n = parseInt("not_a_number")
except ValueError:
  echo "That failed"

let maybe = some("found")
if maybe.isSome: echo maybe.get()
```

## Test it

Run `test_it.nim` — it implements `safeDivide` that returns `Option[float]`
and `none` when b is 0. Chain it: `safeDivide(10, 2).flatMap(safeDivide(it, 5))`.
Change the values, test with zero, combine with `try/except`.
