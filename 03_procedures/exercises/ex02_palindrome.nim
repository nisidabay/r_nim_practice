# Exercise 2: Palindrome Checker
import std/strutils

proc reverse(s: string): string =
  result = newString(s.len)
  for i, c in s:
    result[s.len - 1 - i] = c

echo "racecar".reverse()
echo "racecar" == "racecar".reverse()   # true
