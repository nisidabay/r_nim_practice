# Exercise 1: Multiplication Table
# Print a 5×5 multiplication table as a formatted grid.
import std/strutils

for row in 1..5:
  for col in 1..5:
    write(stdout, align($(row * col), 3))
  echo ""
