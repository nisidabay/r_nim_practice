# Nim types: int, float, string, char, bool — all inferred or explicit.
import std/strformat

let age = 42                      # inferred int
var name: string = "Carlos"       # explicit string
const PI = 3.14159               # compile-time constant
var active: bool = true
var letter: char = 'z'             # char is 1 byte — ASCII only

echo fmt"{name} is {age}. Active? {active}. Pi ≈ {PI}"
echo fmt"First char of name: {letter} (char, not string)"

# Numeric types
let count: int16 = 32767          # 16-bit
let big: int64 = 9999999999       # 64-bit
let price: float = 19.99          # always float64, no float32 by default
echo fmt"count={count}, big={big}, price={price}"

# String concatenation and interpolation
echo name & " owes $" & $price    # & for concat, $ to stringify
echo fmt"{name} owes ${price}"    # strformat (requires import std/strformat)

# ── Thinking in Nim ────────────────────────────
# Nim's type system is explicit when you want it and invisible when you don't,
# inferring int/string/bool while still letting you pick exact widths (int16, int64).
# char is ASCII-only in Nim, and float is always float64 by default.
# Everything stringifies via $ and concatenates with &, so types stay strict, not sloppy.
