# nim c -r csv_parser.nim <filename>
# Read a CSV file, split lines, trim fields, align columns.
import std/[os, strutils]

if paramCount() < 1:
  echo "Usage: csv_parser <filename>"
  echo "  e.g. csv_parser data.csv"
  quit(1)

let filename = paramStr(1)
if not fileExists(filename):
  echo "File not found: ", filename
  quit(1)

let content = readFile(filename)
var lines = content.splitLines()
if lines.len == 0 or (lines.len == 1 and lines[0].len == 0):
  echo "Empty file."
  quit(0)

# Remove empty trailing lines
while lines.len > 0 and lines[^1].strip().len == 0:
  lines.del(lines.high)

# Parse all rows into fields
var rows: seq[seq[string]] = @[]
var colWidths: seq[int] = @[]

for line in lines:
  let stripped = line.strip()
  if stripped.len == 0:
    continue
  let fields = stripped.split(',')
  var rowFields: seq[string] = @[]
  for f in fields:
    rowFields.add(f.strip())
  rows.add(rowFields)

  # Track max width per column
  for i, f in rowFields.pairs:
    if i >= colWidths.len:
      colWidths.add(f.len)
    elif f.len > colWidths[i]:
      colWidths[i] = f.len

# Print aligned rows
for row in rows:
  var outLine = ""
  for i, f in row.pairs:
    if i > 0:
      outLine.add("  ")
    let width = if i < colWidths.len: colWidths[i] else: f.len
    outLine.add(f.alignLeft(width))
  echo outLine