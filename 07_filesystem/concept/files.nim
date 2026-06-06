# nim c -r files.nim
# readFile, writeFile, readLines — basic file I/O.

import std/os

let filename = "/tmp/nim_demo.txt"

# Write
writeFile(filename, "line one\nline two\nline three\n")
echo "Wrote: ", filename

# Read entire file
let content = readFile(filename)
echo content

# Read line by line
for line in lines(filename):
  echo "> ", line

# readLines returns a seq
let all = readLines(filename)
echo "Number of lines: ", all.len

# Exists? Remove?
echo "Exists? ", fileExists(filename)
removeFile(filename)
echo "Now? ", fileExists(filename)
