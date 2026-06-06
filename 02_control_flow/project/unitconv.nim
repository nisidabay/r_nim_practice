# nim c -r unitconv.nim <value> <from_unit> <to_unit>
# Convert between km/miles, kg/lbs, C/F.
import std/[os, strutils]

if paramCount() < 3:
  echo "Usage: unitconv <value> <from> <to>"
  echo "  e.g. unitconv 10 km miles"
  echo "  km/miles, kg/lbs, C/F"
  quit(1)

let
  val = parseFloat(paramStr(1))
  fromUnit = paramStr(2).toLowerAscii()
  toUnit = paramStr(3).toLowerAscii()

proc convert(value: float, fromU, toU: string): float =
  case fromU & "→" & toU:
  of "km→miles": value * 0.621371
  of "miles→km": value / 0.621371
  of "kg→lbs": value * 2.20462
  of "lbs→kg": value / 2.20462
  of "c→f": value * 9/5 + 32
  of "f→c": (value - 32) * 5/9
  else:
    echo "Unsupported conversion: ", fromU, " → ", toU
    quit(1)

let result = convert(val, fromUnit, toUnit)
echo val.formatBiggestFloat(ffDecimal), " ", fromUnit,
     " = ", result.formatBiggestFloat(ffDecimal), " ", toUnit
