# nim c -r loops.nim

echo "=== for loops ==="

for i in 1 .. 5:                  # inclusive range
  echo i

for i in 0 ..< 5:                 # exclusive of end (0,1,2,3,4)
  echo i

echo ""

for c in "Nim":                   # iterate over string chars
  echo c

echo ""

# Countdown
for i in countdown(5, 1):
  echo i

echo "\n=== while ==="

var x = 0
while x < 3:
  echo x
  x += 1                          # no ++ operator in Nim

echo "\n=== break / continue ==="

for i in 1 .. 10:
  if i == 4: continue             # skip 4
  if i == 7: break                # stop at 7
  echo i
