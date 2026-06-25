# 06 Collections — Test It
# Count word frequencies with CountTable and find the most frequent word.
# Uses ONLY: tables, split (strutils), pairs iteration.

import std/[tables, strutils]

let text = "nim is fast nim is elegant nim is fun and python is also fun but nim is faster"

let words = text.split()
var counts = words.toCountTable()

echo "Word frequencies:"
for word, count in pairs(counts):
  echo "  ", word, ": ", count

var bestWord = ""
var bestCount = 0
for word, count in pairs(counts):
  if count > bestCount:
    bestCount = count
    bestWord = word

echo "\nMost frequent word: '", bestWord, "' (", bestCount, " times)"

# Try using a longer text (paste a paragraph).
# Try case-insensitive counting with toLower.
# Try finding the least frequent word instead.
# Try using a HashSet to collect unique words.
