# nim c -r csv_parser.nim
# Read CSV data from stdin, split lines, trim fields, align columns.
import std/[os, strutils]
# NOTE: For reading real files, see Module 07 (filesystem).

proc printUsage() =
  echo "Usage: echo <csv-data> | nim c -r csv_parser.nim"
  echo "  Reads CSV from stdin and prints an aligned table."
  echo "  Example: echo \"name,age,city\" | nim c -r csv_parser.nim"

proc parseLines(): seq[seq[string]] =
  result = @[]
  while not stdin.endOfFile():
    let line = stdin.readLine().strip()
    if line.len == 0:
      continue
    let fields = line.split(',')
    var row: seq[string] = @[]
    for f in fields:
      row.add(f.strip())
    result.add(row)

proc colWidths(rows: seq[seq[string]]): seq[int] =
  result = @[]
  for row in rows:
    for i, f in row:
      if i >= result.len:
        result.add(f.len)
      elif f.len > result[i]:
        result[i] = f.len

proc sepLine(widths: seq[int]): string =
  var parts: seq[string] = @[]
  for w in widths:
    parts.add(repeat('-', w))
  result = parts.join(" + ")

proc display(rows: seq[seq[string]]; widths: seq[int]) =
  for i, row in rows:
    var parts: seq[string] = @[]
    for j, f in row:
      parts.add(f.alignLeft(widths[j]))
    echo "  ", parts.join(" | ")
    if i == 0:
      echo "  ", sepLine(widths)

# --- Main ---
if paramCount() > 0 and paramStr(1) in ["--help", "-h"]:
  printUsage()
  quit(0)

let rows = parseLines()
if rows.len == 0:
  printUsage()
  quit(0)

let widths = colWidths(rows)
display(rows, widths)
