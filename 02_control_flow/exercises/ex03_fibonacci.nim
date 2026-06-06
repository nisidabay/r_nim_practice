# Exercise 3: Fibonacci Iterator
# Custom iterator that yields Fibonacci numbers up to a limit.
iterator fibonacci(limit: int): int =
  var (a, b) = (0, 1)
  while a <= limit:
    yield a
    (a, b) = (b, a + b)

for n in fibonacci(100):
  echo n
