# Exercise 3: Word Count
import std/strutils, std/tables

let text = "Nim is fast. Nim is expressive. Nim compiles to C."
var words = initCountTable[string]()
for w in text.split({' ', '.', ','}):
  let clean = w.toLowerAscii().strip()
  if clean.len > 0:
    words.inc(clean)
words.sort()
for word, count in words.pairs:
  echo word, ": ", count
