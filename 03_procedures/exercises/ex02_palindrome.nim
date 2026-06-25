# Exercise 2: Palindrome Checker
import std/strutils

proc reverse(s: string): string =
  result = ""
  for i in 0 ..< s.len:
    result = s[i] & result

echo "racecar".reverse()
echo "racecar" == "racecar".reverse()   # true
