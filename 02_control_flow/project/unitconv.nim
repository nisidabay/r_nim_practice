# nim c -r unitconv.nim <value> <from_unit> <to_unit>
# Convert between km/miles, kg/lbs, C/F.
import std/[os, strutils]

if paramCount() < 3:
  echo "Usage: unitconv <value> <from> <to>"
  echo "  e.g. unitconv 10 km miles"
  echo "  km/miles, kg/lbs, c/f"
  quit(1)

let val = parseFloat(paramStr(1))
let fromUnit = paramStr(2)
let toUnit = paramStr(3)

var result: float
if fromUnit == "km" and toUnit == "miles":
  result = val * 0.621371
elif fromUnit == "miles" and toUnit == "km":
  result = val / 0.621371
elif fromUnit == "kg" and toUnit == "lbs":
  result = val * 2.20462
elif fromUnit == "lbs" and toUnit == "kg":
  result = val / 2.20462
elif fromUnit == "c" and toUnit == "f":
  result = val * 9.0 / 5.0 + 32.0
elif fromUnit == "f" and toUnit == "c":
  result = (val - 32.0) * 5.0 / 9.0
else:
  echo "Unsupported conversion: ", fromUnit, " -> ", toUnit
  quit(1)

echo val, " ", fromUnit, " = ", result, " ", toUnit
