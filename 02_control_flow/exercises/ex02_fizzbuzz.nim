# Exercise 2: FizzBuzz
# Print 1..100: multiples of 3 → "Fizz", multiples of 5 → "Buzz",
# multiples of both → "FizzBuzz", otherwise the number.
for i in 1..100:
  if i mod 15 == 0: echo "FizzBuzz"
  elif i mod 3 == 0: echo "Fizz"
  elif i mod 5 == 0: echo "Buzz"
  else: echo i
