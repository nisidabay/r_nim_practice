# Nim
#
# Guessing game

import std/[random, strutils, strformat]

proc playGuessingGame() =
  # Seed the random number generator
  randomize()

  let secret = rand(1..100)
  var guess = 0
  var attempts = 0

  echo "I have selected a number between 1 and 100."

  while guess != secret:
    stdout.write("Enter your guess: ")

    try:
      # Read line from stdin and parse to integer immediately
      guess = stdin.readLine.parseInt()
      attempts += 1

      if guess < secret:
        echo "Too low! Try again."
      elif guess > secret:
        echo "Too high! Try again."
      else:
        # Use fmt for string interpolation
        echo fmt"Correct! You found {secret} in {attempts} attempts."

    except ValueError:
      echo "That doesn't look like a valid number. Please enter an integer."

when isMainModule:
  playGuessingGame()
