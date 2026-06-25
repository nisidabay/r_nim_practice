# 03 Procedures — Functions, UFCS, Templates

## Quick Start

```bash
nim c -r 03_procedures/concept/procedures.nim
nim c -r 03_procedures/concept/ufcs.nim
nim c -r 03_procedures/concept/templates.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `procedures.nim` | proc, func, return, result, defaults | Syntax diagram: `proc name(params): type = body`; `func` = no side effects; `result` is implicit return variable; `{.discardable.}` pragma |
| `ufcs.nim` | Unified Function Call Syntax | `obj.method()` ≡ `method(obj)` — pipeline style |
| `templates.nim` | Templates: compile-time code substitution | Template body is pasted at call site; no runtime overhead |

## Common Patterns

```nim
proc add(a, b: int): int = a + b
proc greet(name: string = "Carlos") = echo "Hola, " & name

# UFCS: both the same
"hello world".toUpperAscii()
toUpperAscii("hello world")
```

## Test it

Run `test_it.nim` — it implements `formatCurrency(amount: float, symbol: string): string`
that returns `"$19.99"`. Try it with UFCS: `19.99.formatCurrency("$")`.
Change the symbol, change the decimals, add thousands separators.
