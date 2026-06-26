# Exercise 1: Multiplication Table
# Print a 5×5 multiplication table as a formatted grid.

for row in 1..5:
  var line = ""
  for col in 1..5:
    let n = row * col
    let s = $n
    if s.len < 2: line.add " "
    line.add " " & s
  echo line
