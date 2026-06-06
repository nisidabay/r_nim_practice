# Exercise 3: Zip + Filter
import std/sequtils

let names = @["Carlos", "Ana", "Luis"]
let scores = @[85, 92, 78]

# Zip pairs them together, filter keeps only those above 80
let passing = zip(names, scores).filterIt(it[1] > 80)
for (name, score) in passing:
  echo name, ": ", score
