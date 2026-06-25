# 08 Error Handling — Test It
# safeDivide returning Option[float], chainable with flatMap.
# Uses ONLY: options (taught in option.nim), regular procs.

import std/options

proc safeDivide(a, b: float): Option[float] =
  if b == 0.0:
    none[float]()
  else:
    some(a / b)

# Helper proc for chaining (no sugar/=> needed)
proc divideByFive(x: float): Option[float] =
  safeDivide(x, 5.0)

# Basic usage
let r1 = safeDivide(10.0, 2.0)
echo "10 / 2 = ", r1.get(0.0)

let r2 = safeDivide(10.0, 0.0)
echo "10 / 0 = ", r2.get(0.0)

# Chaining with flatMap (uses a regular proc, just like option.nim teaches)
let chained = safeDivide(10.0, 2.0).flatMap(divideByFive)
echo "10 / 2 / 5 = ", chained.get(0.0)

# Chain that hits zero in the middle — none propagates
let broken = safeDivide(10.0, 0.0).flatMap(divideByFive)
echo "10 / 0 / 5 = ", broken.get(0.0), " (expected 0 — none propagates)"

# Try combining with try/except instead of Option.
# Try adding a safeMultiply or safeSqrt.
# Try using map to transform the result (e.g. round to 2 decimals).
