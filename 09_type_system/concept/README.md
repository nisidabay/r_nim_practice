# 09 Type System — Distinct Types, Variants, and Compile-Time

## Quick Start

```bash
nim c -r 09_type_system/concept/distinct.nim
nim c -r 09_type_system/concept/variants.nim
nim c -r 09_type_system/concept/compiletime.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `distinct.nim` | Distinct types: compiler-enforced type safety | `Euros = distinct float64` — can't mix with `Dollars` |
| `variants.nim` | Variant objects: value is one of several shapes | `case kind` inside an object — tagged unions |
| `compiletime.nim` | Compile-time execution: `when`, `const` | Run code DURING compilation, not at runtime |

## Common Patterns

```nim
type Euros = distinct float64
var price: Euros = 19.99.Euros
# price + 5.0  # compile error — distinct types refuse to mix
```

## Now Build Your Own

Define `type Celsius = distinct float` and `Fahrenheit = distinct float`. Write
conversion procs between them. The compiler must prevent mixing accidentally.
