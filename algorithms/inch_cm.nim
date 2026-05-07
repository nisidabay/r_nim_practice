import strutils, strformat

proc header() =
  stdout.writeLine(" in |    cm")
  stdout.writeLine("----|--------")
  stdout.flushFile()

proc inToCm(n: int): float =
  return float(n) * 2.54

header()
for n in 1 .. 10:
  let
    inches = alignLeft($(n), 3)
    cmValue = inToCm(n)
    centimetersStr = fmt"{cmValue:.2f}"
    centimeters = align(centimetersStr, 6)
  echo inches & " | " & centimeters

