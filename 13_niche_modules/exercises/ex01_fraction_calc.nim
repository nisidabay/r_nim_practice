# ex01_fraction_calc.nim — CLI fraction calculator
#   nim c -r exercises/ex01_fraction_calc.nim

import std/rationals, std/strutils, std/stats

# ── Parse "a/b" string → Rational[int] ──────────────────────────────────

proc parseFraction(s: string): Rational[int] =
  let parts = s.split('/')
  assert parts.len == 2, "Expected format a/b"
  result = initRational(parseInt(parts[0]), parseInt(parts[1]))

# ── Test cases ──────────────────────────────────────────────────────────

# Test 1: 1/2 + 1/3 = 5/6
let a = parseFraction("1/2")
let b = parseFraction("1/3")
assert a + b == 5 // 6

# Test 2: 3/4 - 1/4 = 1/2
let c = parseFraction("3/4")
let d = parseFraction("1/4")
assert c - d == 1 // 2

# Test 3: 2/5 * 5/8 = 1/4
let e = parseFraction("2/5")
let f = parseFraction("5/8")
assert e * f == 1 // 4

echo "ex01_fraction_calc: All fraction assertions passed."

# ── Bonus: mean of fractions using RunningStat ──────────────────────────

var rs: RunningStat
for val in [1 // 2, 3 // 2]:
  rs.push(toFloat(val))
assert abs(rs.mean - 1.0) < 1e-10
echo "Fraction mean: ", rs.mean