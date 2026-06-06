# nim c -r iterators.nim
# Iterators yield values one at a time — they don't build the whole list in memory.

# Simple iterator
iterator countTo(n: int): int =
  var i = 1
  while i <= n:
    yield i
    inc i

for x in countTo(3):
  echo x

# Inline iterator (inlined at compile time for speed)
iterator oddNumbers(limit: int): int {.inline.} =
  var i = 1
  while i <= limit:
    yield i
    i += 2

echo "---"
for x in oddNumbers(9):
  echo x
