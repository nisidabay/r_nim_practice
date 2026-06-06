# Exercise 3: Compile-Time Factorial
proc factorial(n: int): int =
  if n < 2: 1 else: n * factorial(n-1)

const f5 = factorial(5)
echo "5! computed at compile time: ", f5
echo "Runtime: 7! = ", factorial(7)
