# nim c -r counter.nim <filename>
# Count word frequencies in a text file, print top 10.
import std/[tables, algorithm, os, strutils]

if paramCount() < 1:
  echo "Usage: counter <filename>"
  quit(1)

let filename = paramStr(1)
if not fileExists(filename):
  echo "File not found: ", filename
  quit(1)

var counts = initCountTable[string]()
for line in lines(filename):
  for word in line.split({' ', '\t', ',', '.', '!', '?'}):
    let w = word.toLowerAscii().strip()
    if w.len > 1: counts.inc(w)

counts.sort()
var printed = 0
for word, count in counts.pairs:
  echo word.alignLeft(20), count
  inc printed
  if printed >= 10: break
