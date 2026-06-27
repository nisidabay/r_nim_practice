# Exercise 3: Fibonacci Iterator
# Custom iterator that yields Fibonacci numbers up to a limit.
iterator fibonacci(limit: int64): int64 {.inline.} =
  var a = 0'i64
  var b = 1'i64

  while a <= limit:
    yield a
    let next = a + b
    a = b
    b = next

for n in fibonacci(1000):
  echo n

