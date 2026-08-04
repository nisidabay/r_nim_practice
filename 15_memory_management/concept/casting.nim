# How do I convert types safely? — casting vs parentheses conversion
#   nim c -r casting.nim
#
# Nim separates TWO operations people loosely call "cast":
#   T(x)   — safe conversion. Real value transformation, range-checked.
#   cast[T](x) — bit reinterpretation. No conversion, no checks. Careful!

# ── T(x): the safe, checked conversion ──────────────────────────────────

var score = 95.7
let whole = int(score)               # 95 — drops the fraction
var deg = 38.0
echo "score as int: ", whole
echo "deg as int:   ", int(deg)

let small: uint8 = uint8(200)        # fits, fine
echo "small = ", small
# let tooBig = uint8(300)            # compile error: 300 doesn't fit uint8
# Range-checking happens at compile time when the value is a constant.

# ── chars and enums convert the same way ────────────────────────────────

type Color = enum red, green, blue

echo "char(65) = '", char(65), "'"            # 'A'
echo "ord(red) = ", ord(red)                  # 0
echo "Color(1) = ", Color(1)                  # green
echo "green.int = ", green.int                # 1 — `.int` is shorthand

# Parentheses conversion does a REAL numeric transform, so int→float and
# enum→int all behave as you'd expect. That's the safe path.

# ── cast[T]: reinterprets raw bits, no conversion ───────────────────────

let signed = -1.int8                    # -1 fits in int8 (range -128..127)
let reCoded = cast[uint8](signed)            # same bits, different lens
echo "-1.int8 bits -> uint8 = ", reCoded   # 255 — the raw 11111111 bits
# cast did NOT convert -1 → 255 numerically. It kept the memory bits and
# re-labelled them as uint8, so the value read as 255. Nice when the bits
# mean what you expect, a trap otherwise.

# ── cast for pointers: the low-level escape hatch ───────────────────────

var px = 42
let rawPtr = cast[pointer](addr(px))         # value -> raw memory address
echo "px bytes live at frame = ", cast[int](rawPtr)

# cast is how you move between pointers and integers for FFI / unmanaged
# memory. Only do this when you truly own the bits — the compiler will NOT
# protect you from your own reinterpretation.

# ── Rule of thumb ───────────────────────────────────────────────────────
# Reach for parentheses `T(x)` for any REAL conversion (numbers, chars,
# enums): it transforms the value and the compiler checks the range.
# Reserve `cast[T](x)` for reinterpreting bits or pointer work where you
# already know exactly what the memory contains.

# ── Thinking in Nim ────────────────────────────
# Nim's split between `T(x)` and `cast[T](x)` is the core of its type
# story: a parenthesized conversion preserves the *meaning* of a value
# (and is checked), while `cast` preserves only the *bits* (and is
# unchecked). Reach for the former every day; reserve `cast` for the
# moments you are deliberately leaving the safe lanes of the type system.
