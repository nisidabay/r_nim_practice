# 03 Procedures — Functions, UFCS, Templates

## Quick Start

```bash
nim c -r 03_procedures/concept/procedures.nim
nim c -r 03_procedures/concept/ufcs.nim
nim c -r 03_procedures/concept/templates.nim
nim c -r 03_procedures/concept/time_tour.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `procedures.nim` | proc, return, result, defaults | `result` is implicit return variable; `{.discardable.}` pragma |
| `ufcs.nim` | Unified Function Call Syntax | `obj.method()` ≡ `method(obj)` — pipeline style |
| `templates.nim` | Templates: compile-time code substitution | Template body is pasted at call site; no runtime overhead |
| `time_tour.nim` | DateTime, Duration, MonoTime | Parse, format, measure elapsed time |

## Common Patterns

```nim
proc add(a, b: int): int = a + b
proc greet(name: string = "Carlos") = echo "Hola, " & name

# UFCS: both the same
"hello world".toUpperAscii()
toUpperAscii("hello world")
```

## Now Build Your Own

Write a `formatCurrency(amount: float, symbol: string)` proc that returns
`"$19.99"`. Call it via UFCS: `19.99.formatCurrency("$")`.
