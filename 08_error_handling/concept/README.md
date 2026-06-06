# 08 Error Handling — Exceptions and Option Types

## Quick Start

```bash
nim c -r 08_error_handling/concept/try_except.nim
nim c -r 08_error_handling/concept/option.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `try_except.nim` | try/except/finally, raise, custom exceptions | Multiple except branches, `as e` binding |
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

## Now Build Your Own

Write a `safeDivide(a, b: float): Option[float]` that returns none if b is zero.
Chain two divisions: `safeDivide(10, 2).flatMap(safeDivide(it, 5))`.
