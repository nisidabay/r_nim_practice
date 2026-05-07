# FizzBuzz example

proc printFizzBuzz(n: int): seq[string] =
  result = @[]
  if n mod 15 == 0:
    result.add("fizzbuzz")
  elif n mod 3 == 0:
    result.add("fizz")
  elif n mod 5 == 0:
    result.add("buzz")
  else:
    result.add($n)
  return result

for n in 1..30:
  stdout.write(printFizzBuzz(n))
  if n < 30:
    stdout.write("-")
  stdout.flushFile()
