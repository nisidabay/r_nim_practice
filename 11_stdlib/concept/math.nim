# std/math — sum, min, max, round, sqrt, PI, and more
#   nim c -r concept/math.nim

import std/math

# ── sum, min, max — operate on collections ──────────────────────────────

let vals = @[1.0, 2.0, 3.0, 4.0, 5.0]
echo "sum  = ", sum(vals)      # 15.0
echo "min  = ", min(vals)      # 1.0
echo "max  = ", max(vals)      # 5.0

echo "mean = ", sum(vals) / vals.len.float   # 3.0

# ── round — control decimal places ───────────────────────────────────────

echo round(PI, 2)              # 3.14
echo round(PI, 4)              # 3.1416

# ── sqrt — square root ──────────────────────────────────────────────────

echo sqrt(144.0)               # 12.0

# sqrt works on floats — convert ints explicitly
echo sqrt(float(144))          # 12.0

# ── floorDiv, floorMod — integer division with floor semantics ──────────

echo floorDiv(7, 3)            # 2
echo floorMod(7, 3)            # 1

# ── Trigonometric (radians) ─────────────────────────────────────────────

echo sin(PI / 2)               # 1.0
echo cos(PI)                   # -1.0
echo arctan(1.0)               # 0.785398... (PI/4)

# ── ceil, floor — integer rounding ──────────────────────────────────────

echo ceil(3.1)                 # 4.0
echo floor(3.9)                # 3.0

# ── Verification ────────────────────────────────────────────────────────

assert sum(vals) == 15.0
assert min(vals) == 1.0
assert max(vals) == 5.0
assert abs(round(PI, 2) - 3.14) < 1e-10
assert sqrt(144.0) == 12.0

echo "All math assertions passed."
