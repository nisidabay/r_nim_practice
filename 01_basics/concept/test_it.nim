# 01 Basics — Test It
# Ask for name and birth year, calculate age.
# Combine what you learned from hello.nim and input.nim.

import std/strutils

echo "What's your name?"
let name = readLine(stdin)

echo "What year were you born?"
let birthYear = parseInt(readLine(stdin))

let age = 2026 - birthYear

echo "Hello, ", name, "! You are ", age, " years old (or will be this year)."

# Try changing the message format.
# Try handling negative ages (if birth year > 2026).
# What happens if you type "abc" instead of a number?
