# Fortune like Nim application
import std/random
import std/strutils
import std/os

proc main() =
  randomize()

  let appDir = expandTilde("~/bin/fortune")
  let filename = joinPath(appDir, "Computer_Quotes.txt")
  let separator = "#"
  var content = ""

  try:
    # Read the entire file contents
    # readFile throws an IOError if it can't open the file
    content = readFile(filename)
  except IOError as e:
    # Handle file opening/reading errors
    stderr.writeLine("Error opening file: " & e.msg)

  # Split into lines and collect non-empty ones
  var quotes: seq[string] = @[]

  for line in content.split(separator):
    let trimmed = line.strip()
    if trimmed.len > 0:
      quotes.add(trimmed)

  if quotes.len == 0:
    stderr.writeLine("No quotes found in the file.")
    return

  # Generate random index and pick item (sample is equivalent to random choice)
  let quote = sample(quotes)

  # Print to stdout
  echo quote


when isMainModule:
  main()
