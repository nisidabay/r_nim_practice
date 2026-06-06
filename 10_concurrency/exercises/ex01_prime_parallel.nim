# Exercise 1: Count primes in parallel
import std/threadpool, std/math
{.experimental: "parallel".}

proc isPrime(n: int): bool =
  if n < 2: return false
  let limit = int(sqrt(n.float))
  for i in 2 .. limit:
    if n mod i == 0: return false
  true

proc countPrimes(start, stop: int): int =
  for n in start .. stop:
    if n.isPrime(): inc result

# Compute primes in 4 ranges concurrently
var results = newSeq[int](4)
parallel:
  for i in 0..3:
    results[i] = spawn countPrimes(i*250_000 + 1, (i+1)*250_000)

echo "Primes found:"
for i in 0..3:
  echo "  Range ", i, ": ", results[i]
