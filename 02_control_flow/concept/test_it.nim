# 02 Control Flow — Test It
# Nested for loops: multiplication table 1 to 5.
# Uses ONLY: echo, for, string concatenation (&), $ for conversion.

for i in 1..5:
  var line = ""
  for j in 1..5:
    line = line & $(i * j) & " "
  echo line

# Try changing the range from 1..5 to 1..10.
# Try using while loops instead of for.
# Try using & "\t" (tab) instead of & " " between numbers.
# Try printing "i x j = result" for each cell.
