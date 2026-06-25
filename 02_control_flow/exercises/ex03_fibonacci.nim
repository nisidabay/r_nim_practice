# Exercise 3: Fibonacci Iterator
# Custom iterator that yields Fibonacci numbers up to a limit.
iterator fibonacci(limit: int): int =
  var a = 0
  var b = 1
  while a <= limit:
    yield a
    let temp = a + b
    a = b
    b = temp

for n in fibonacci(100):
  echo n
