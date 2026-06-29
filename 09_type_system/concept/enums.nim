# nim c -r enums.nim
#
# Enums give names to integer values. They make code self-documenting —
# no more guessing what 0, 1, 2 mean.

type
  Color = enum
    red, green, blue

var c: Color = red
echo c                            # red

# ── Ordinal values ─────────────────────────────────────────────────────
# Each symbol maps to an int starting at 0

echo ord(red)                     # 0
echo ord(green)                   # 1
echo ord(blue)                    # 2

# ── Iteration ──────────────────────────────────────────────────────────

for s in red..blue:
  echo s, " = ", ord(s)

# ── Explicit values ────────────────────────────────────────────────────

type
  HttpCode = enum
    ok = 200, notFound = 404, error = 500

echo ok, " = ", ord(ok)           # 200
echo notFound, " = ", ord(notFound) # 404

# ── No scope prefix needed ─────────────────────────────────────────────
# In C++, Rust, and other languages, enum symbols are scoped inside the
# type name. In Nim, they become direct values in the current scope —
# you write `red`, not `Color.red`. Clean and simple.
