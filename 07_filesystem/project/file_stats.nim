# nim c -r file_stats.nim <filename>
# Print line, word, character counts and longest line length for a text file.
import std/[os, strutils]

if paramCount() < 1:
  echo "Usage: file_stats <filename>"
  quit(1)

let filename = paramStr(1)

# Read entire file — raises IOError if file does not exist
let content = try:
    readFile(filename)
  except IOError:
    echo "File not found: ", filename
    quit(1)

# Split into lines and remove trailing empty line caused by trailing newline
let rawLines = content.splitLines()
var lines: seq[string]
if rawLines.len > 0 and rawLines[^1] == "":
  lines = rawLines[0 .. ^2]
else:
  lines = rawLines

# Compute statistics
let lineCount = lines.len
var wordCount = 0
var longestLine = 0
for line in lines:
  wordCount += line.split().len
  if line.len > longestLine:
    longestLine = line.len

let charCount = content.len

# Output
echo "File: ", filename
echo "Lines:     ", lineCount
echo "Words:     ", wordCount
echo "Characters: ", charCount
echo "Longest line: ", longestLine, " characters"
