# nim c -r greeting.nim <name> <birth_year>
# CLI that greets you and prints your age.
import std/[os, strutils]

if paramCount() < 2:
  echo "Usage: greeting <name> <birth_year>"
  echo "  e.g. greeting Alice 1990"
  quit(1)

let
  name = paramStr(1)
  birthYear = parseInt(paramStr(2))

let currentYear = 2026
let age = currentYear - birthYear

echo "Hello, ", name, "!"
echo "You are ", age, " years old (or will be this year)."

