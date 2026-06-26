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
