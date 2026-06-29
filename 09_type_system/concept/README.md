# 09 Type System — Distinct Types, Variants, Generics, Enums, Tuples, OOP, and Compile-Time

## Quick Start

```bash
nim c -r 09_type_system/concept/distinct.nim
nim c -r 09_type_system/concept/variants.nim
nim c -r 09_type_system/concept/tuples.nim
nim c -r 09_type_system/concept/enums.nim
nim c -r 09_type_system/concept/oop.nim
nim c -r 09_type_system/concept/compiletime.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `distinct.nim` | Distinct types: compiler-enforced type safety | `Euros = distinct float64` — can't mix with `Dollars` |
| `variants.nim` | Variant objects: value is one of several shapes | `case kind` inside an object — tagged unions |
| `enums.nim` | Enums: basic syntax, ordinal values, iteration, explicit values | `Color = enum red, green, blue`; `ord(red)`; `for s in red..blue` |
| `tuples.nim` | Tuples: positional, named, unpacking | `var point = (10, 20)`; `let (a,b) = point` |
| `oop.nim` | Ref objects, inheritance, method dispatch | `ref object`, `of` inheritance, `method` vs `proc` dispatch |
| `compiletime.nim` | Compile-time execution: `when`, `const` | Run code DURING compilation, not at runtime |
| `generics.nim` | Generics and type constraints | `proc foo[T](x: T): T`; `[T: SomeNumber]` restricts T to numeric types |

## Common Patterns

```nim
type Euros = distinct float64
var price: Euros = 19.99.Euros
# price + 5.0  # compile error — distinct types refuse to mix

type
  Animal = ref object of RootObj
    name: string
  Dog = ref object of Animal
    breed: string

method speak(a: Animal): string {.base.}
method speak(d: Dog): string = "Woof!"
```

## Test it

Run `test_it.nim` — it defines `type Celsius = distinct float` and
`Fahrenheit = distinct float`, with conversions between them. Try adding
Celsius + Fahrenheit — the compiler stops you. That's type safety in action.
