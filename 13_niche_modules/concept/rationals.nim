# std/rationals — exact arithmetic with fractions
#   nim c -r concept/rationals.nim

import std/rationals

# ── Construction ─────────────────────────────────────────────────────────

let a = initRational(1, 3)          # 1/3
let b = 1 // 3                      # same, using // operator
echo "a = ", a                      # "1/3"
echo "b = ", b                      # "1/3"

# ── Arithmetic ───────────────────────────────────────────────────────────

let sum = 1 // 3 + 1 // 3           # 2/3
let diff = 3 // 4 - 1 // 4          # 1/2
let prod = (2 // 5) * (3 // 4)      # 6/20 = 3/10
let quot = (2 // 3) / (4 // 5)      # (2/3) / (4/5) = 10/12 = 5/6

echo "1/3 + 1/3 = ", sum
echo "3/4 - 1/4 = ", diff
echo "2/5 * 3/4 = ", prod

# ── Conversion ───────────────────────────────────────────────────────────

echo "toFloat(2//3) = ", toFloat(2 // 3)   # 0.6666667
echo "string: $ ", $ (7 // 3)              # "7/3"

# ── Comparison ───────────────────────────────────────────────────────────

echo "1//3 == 2//6 ? ", (1 // 3) == (2 // 6)  # true
echo "abs(-5//3) = ", abs(-5 // 3)

# ── Verification ────────────────────────────────────────────────────────

assert 1 // 3 + 1 // 3 == 2 // 3
assert toFloat(2 // 3) == 2.0 / 3.0
assert 3 // 4 - 1 // 4 == 1 // 2
assert (2 // 5) * (3 // 4) == 3 // 10  # 6/20 simplifies to 3/10

echo "All rationals assertions passed."