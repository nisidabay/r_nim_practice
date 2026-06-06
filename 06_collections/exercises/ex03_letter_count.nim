# Exercise 3: Letter Frequency
import std/tables

let text = "nim is a compiled language with python-like syntax"
var freqs = initCountTable[char]()
for c in text:
  if c != ' ':
    freqs.inc(c)
freqs.sort()
for c, ct in freqs.pairs:
  echo c, ": ", ct
