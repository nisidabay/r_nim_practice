# Exercise 2: Palindrome Checker
import std/[os, strformat]

let
  progName = paramStr(0)
  progArgsCount = paramCount()

if progArgsCount < 1 or progArgsCount > 1:
  echo fmt"Usage: {progName} <word>"
  quit(1)

let word = paramStr(1)

proc reverse(s: string): string =
  result = ""
  for i in 0 ..< s.len:
    result = s[i] & result
    echo result

if word == word.reverse():
  echo "This word is a Palindrome"
else:
  echo "This word is not a Palindrome"

