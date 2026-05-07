#[
Collatz conjecture is a popular mathematical problem with simple rules. First
pick a number. If it is odd, multiply it by three and add one; if it is even,
divide it by two. Repeat this procedure until you arrive at one. E.g. 5 → odd →
3*5 + 1 = 16 → even → 16 / 2 = 8 → even → 4 → 2 → 1 → end! Pick an integer (as
a mutable variable) and create a loop which will print every step of the
Collatz conjecture. (Hint: use div for division)
]#

import strutils

# Calculates the next number in a Collatz sequence.
proc nextCollatz(n: Natural): Natural =
  if n mod 2 != 0:
    result = (n * 3) + 1
  else:
    result = n div 2

# Interactively runs the Collatz sequence from a user-provided number.
proc runCollatz() =
  var output: seq[int]
  var number: int

  while true:
    stdout.write("Enter a positive integer: ")
    stdout.flushFile()

    let input = stdin.readLine().strip()
    try:
      number = parseInt(input)
      if number <= 0:
        echo "Please enter a positive integer."
      else:
        break
    except:
      echo "Invalid input. Please enter a valid integer."

  echo "Starting Collatz sequence for: ", number
  output.add(number) # Add the initial number to the sequence

  while number != 1:
    number = nextCollatz(number.Natural) # Cast n to Natural for nextCollatz
    output.add(number)

  echo output

when isMainModule:
  runCollatz()
