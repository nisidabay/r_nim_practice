# Exercise 3: Time Logger
# Measure how long fibonacci takes.
import std/times

proc fib(n: int): int =
  if n < 2: n
  else: fib(n-1) + fib(n-2)

let start = getTime()
let result = fib(35)
let elapsed = getTime() - start
echo "fib(35) = ", result, " in ", elapsed.inMilliseconds, "ms"
