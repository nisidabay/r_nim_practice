# Factorial in nim
proc safeFactorial(n: int): int =
  result = 1
  for i in 2..n:
    # Check if (result * i) would exceed the maximum value for an int
    if result > high(int) div i:
      echo "Error: Result too large for a standard integer at n = ", i
      return -1 # Or handle the error as you prefer
    result *= i

echo safeFactorial(20) # Works
echo safeFactorial(21) # Triggers the safety check
