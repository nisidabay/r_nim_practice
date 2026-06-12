# std/math — arithmetic, trig, logarithms, constants, rounding, conversions
#   nim c -r concept/math.nim

import std/math

# ── Basic arithmetic ─────────────────────────────────────────────────────

echo "sqrt(144) = ", sqrt(144.0)       # 12.0
echo "pow(2, 10) = ", pow(2.0, 10.0)    # 1024.0
echo "abs(-5) = ", abs(-5)              # 5

# ── Trigonometry ─────────────────────────────────────────────────────────

echo "sin(PI / 2) = ", sin(PI / 2)      # 1.0
echo "cos(0.0) = ", cos(0.0)            # 1.0
echo "tan(PI / 4) ≈ ", tan(PI / 4)      # ≈ 1.0

# ── Logarithm / Power ────────────────────────────────────────────────────

echo "log10(1000) = ", log10(1000.0)    # 3.0
echo "ln(E) = ", ln(E)                  # 1.0
echo "log2(8) = ", log2(8.0)            # 3.0

# ── Rounding ─────────────────────────────────────────────────────────────

echo "floor(3.7) = ", floor(3.7)        # 3.0
echo "ceil(3.7) = ", ceil(3.7)          # 4.0
echo "round(3.7) = ", round(3.7)        # 4.0
echo "round(3.4) = ", round(3.4)        # 3.0

# ── Constants ────────────────────────────────────────────────────────────

echo "PI = ", PI                        # 3.141592653589793
echo "E = ", E                          # 2.718281828459045
echo "Inf = ", Inf                      # inf
echo "NaN = ", NaN                      # nan

# ── Conversion ───────────────────────────────────────────────────────────

echo "degToRad(180.0) = ", degToRad(180.0)   # ≈ 3.14159 (PI)
echo "radToDeg(PI) = ", radToDeg(PI)         # 180.0