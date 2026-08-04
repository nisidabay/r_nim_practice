# std/parsecsv — CSV file parser with header support
#   nim c -r parsecsv.nim

import std/parsecsv
import std/os
import std/strutils

# Create sample data for demonstration
let csvContent = """name,age,city
Alice,30,New York
Bob,25,London
Charlie,35,Tokyo
"""

let csvPath = "/tmp/nim_parsecsv_demo.csv"
writeFile(csvPath, csvContent)

# ── Parse CSV with headers ──────────────────────────────────────────────

var parser: CsvParser
parser.open(csvPath, separator = ',', quote = '"')

# Read the first row as headers
parser.readHeaderRow()
echo "Headers: ", parser.headers

# Iterate rows — access by column name via rowEntry
while parser.readRow():
  echo parser.rowEntry("name"), " (", parser.rowEntry("age"), ") — ", parser.rowEntry("city")

parser.close()

# ── Parse CSV without headers ──────────────────────────────────────────

let csvContent2 = """apple,fruit,1.99
broccoli,vegetable,0.99
salmon,fish,5.99
"""

let csvPath2 = "/tmp/nim_parsecsv_demo2.csv"
writeFile(csvPath2, csvContent2)

var parser2: CsvParser
parser2.open(csvPath2, separator = ',', quote = '"')

echo "\nNo-header rows:"
while parser2.readRow():
  echo "  ", parser2.row[0], " — $", parser2.row[2]

parser2.close()

# ── processedRows counter ──────────────────────────────────────────────

let csvContent3 = "x,y\n1,2\n3,4\n5,6\n"
let csvPath3 = "/tmp/nim_parsecsv_demo3.csv"
writeFile(csvPath3, csvContent3)

var parser3: CsvParser
parser3.open(csvPath3)
parser3.readHeaderRow()
while parser3.readRow():
  echo parser3.rowEntry("x"), " + ", parser3.rowEntry("y"), " = ",
       parseInt(parser3.rowEntry("x")) + parseInt(parser3.rowEntry("y"))
echo "Rows processed: ", parser3.processedRows()
parser3.close()

# Cleanup
removeFile(csvPath)
removeFile(csvPath2)
removeFile(csvPath3)

# ── Thinking in Nim ────────────────────────────
# std/parsecsv gives you a streaming row parser built into the stdlib —
# no CSV library to fetch. Headers become named lookups via rowEntry, and
# values arrive as raw strings you parse with parseInt yourself, keeping
# the conversion under your control rather than hidden in the parser.