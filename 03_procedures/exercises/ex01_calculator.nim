# Exercise 1: Calculator
# Write a proc for each operation. Test them all.
proc add(a, b: int): int = a + b
proc sub(a, b: int): int = a - b
proc mul(a, b: int): int = a * b
proc divide(a, b: int): float = a / b

echo add(10, 5)
echo sub(10, 5)
echo mul(10, 5)
echo divide(10, 5)
