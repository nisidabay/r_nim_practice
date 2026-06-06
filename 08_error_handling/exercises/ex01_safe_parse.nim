# Exercise 1: Safe parseInt
import std/strutils

proc safeParse(s: string): int =
  try: result = parseInt(s)
  except ValueError: result = -1

echo safeParse("42")
echo safeParse("not a number")
