# std/strscans — scanf-style pattern matching for strings
#   nim c -r concept/strscans.nim

import std/strscans

# ── Parsing tokens ──────────────────────────────────────────────────────
# $+  = non-whitespace string
# $i  = signed integer
# $f  = floating point number
# $*  = rest of the string

var name: string
var age: int

let line1 = "Name: Alice Age: 30"
if scanf(line1, "Name: $+ Age: $i", name, age):
  echo "Scanned: name = \"", name, "\", age = ", age
else:
  echo "Scan failed"

# ── Float scanning ──────────────────────────────────────────────────────

var product: string
var price: float

let line2 = "Product: Widget Price: 12.50"
if scanf(line2, "Product: $+ Price: $f", product, price):
  echo "Scanned: product = \"", product, "\", price = ", price

# ── Mixed scanning ──────────────────────────────────────────────────────

var city: string
var temp: float
var humidity: int

let line3 = "City: London Temp: 21.5 Humidity: 65"
if scanf(line3, "City: $+ Temp: $f Humidity: $i", city, temp, humidity):
  echo "Weather: ", city, " ", temp, "°C, ", humidity, "% humidity"

# ── Verification ────────────────────────────────────────────────────────

var vname: string
var vage: int
assert scanf(line1, "Name: $+ Age: $i", vname, vage)
assert vname == "Alice"
assert vage == 30

var vprod: string
var vprice: float
assert scanf(line2, "Product: $+ Price: $f", vprod, vprice)
assert vprod == "Widget"
assert abs(vprice - 12.50) < 0.001

echo "All strscans assertions passed."