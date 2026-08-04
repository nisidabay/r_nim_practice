# nim c -r input.nim
# readLine reads from stdin, parse utils convert to numbers.

import std/strutils

echo "Your name: "
let name = readLine(stdin)
echo "Age: "
let ageStr = readLine(stdin)
let age = parseInt(ageStr)

echo "Hola " & name & ", next year you'll be " & $(age + 1)

# parseFloat: floating-point input (same module as parseInt)
echo "Height (m): "
let h = parseFloat(readLine(stdin))
echo "Height in cm: ", h * 100

# ── Thinking in Nim ────────────────────────────
# Nim separates the act of reading from the act of converting: readLine returns a
# string and never guesses, so parse errors surface loudly instead of silently coercing.
# parseInt and parseFloat come from std/strutils, not magic global functions.
# Input stays an explicit string until YOU decide what type it should become.
