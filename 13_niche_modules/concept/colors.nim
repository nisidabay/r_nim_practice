# std/colors — color types, parsing, and named colors
#   nim c -r concept/colors.nim

import std/colors

# ── Constructing colors ─────────────────────────────────────────────────

let red   = rgb(255, 0, 0)
let green = rgb(0, 128, 0)
let blue  = rgb(0, 0, 255)

echo "rgb(255,0,0) = ", red
echo "rgb(0,128,0) = ", green

# ── Parsing named colors ────────────────────────────────────────────────

let col = parseColor("red")
echo "parseColor(\"red\") = ", col

# ── Extracting RGB components ───────────────────────────────────────────

let (r, g, b) = extractRGB(col)
echo "Red components: r=", r, " g=", g, " b=", b

# ── Hex parsing ─────────────────────────────────────────────────────────

let fromHex = parseColor("#00FF00")
let (hr, hg, hb) = extractRGB(fromHex)
echo "#00FF00 → (", hr, ", ", hg, ", ", hb, ")"

# ── Named color parsing ─────────────────────────────────────────────────

for name in ["red", "green", "blue", "yellow", "orange", "purple"]:
  let c = parseColor(name)
  let (cr, cg, cb) = extractRGB(c)
  echo name, " → (", cr, ", ", cg, ", ", cb, ")"

# ── Verification ────────────────────────────────────────────────────────

assert parseColor("red") == rgb(255, 0, 0)
assert parseColor("#00FF00") == rgb(0, 255, 0)
assert parseColor("blue") == rgb(0, 0, 255)

let (vr, vg, vb) = extractRGB(parseColor("yellow"))
assert vr == 255 and vg == 255 and vb == 0

echo "All colors assertions passed."