# Exercise 2: Matrix Transpose
var grid = @[@[1, 2, 3], @[4, 5, 6]]
let rows = grid.len
let cols = grid[0].len
var transposed = newSeq[seq[int]](cols)
for c in 0..<cols:
  transposed[c] = newSeq[int](rows)
  for r in 0..<rows:
    transposed[c][r] = grid[r][c]
echo transposed    # @[@[1,4], @[2,5], @[3,6]]
