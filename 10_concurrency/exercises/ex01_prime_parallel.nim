# Exercise 1: Count primes in parallel
import std/threadpool, std/math
# Using spawn + sync (taught in threads.nim) instead of experimental parallel block

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
var results: array[4, FlowVar[int]]
results[0] = spawn countPrimes(1, 250_000)
results[1] = spawn countPrimes(250_001, 500_000)
results[2] = spawn countPrimes(500_001, 750_000)
results[3] = spawn countPrimes(750_001, 1_000_000)
sync()

echo "Primes found:"
for i in 0..3:
  echo "  Range ", i, ": ", ^results[i]
