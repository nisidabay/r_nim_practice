# nim c -r parse_demo.nim
# parseInt, parseFloat, parseHex, parseEnum — safe conversion with catching.

import std/strutils

# parseInt with exception handling
let raw = "42"
try:
  let n = parseInt(raw)
  echo n, " + 1 = ", n + 1
except ValueError:
  echo raw, " is not an int"

# parseFloat
let pi = parseFloat("3.14159")
echo pi

# parseInt with radix
echo parseHexInt("FF")             # 255 — hex to int

# parseEnum
type Animal = enum
  cat, dog, bird
echo parseEnum[Animal]("dog")    # dog
