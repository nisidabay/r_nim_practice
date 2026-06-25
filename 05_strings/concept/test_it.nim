# 05 Strings — Test It
# Parse a CSV line, strip fields, print aligned.

import std/strutils

let csv = "  Carlos  , 29 ,  Madrid  "
let fields = csv.split(',')
let name = fields[0].strip()
let age = fields[1].strip()
let city = fields[2].strip()

echo alignLeft(name, 12), align(age, 4), "  ", alignLeft(city, 12)

# Try adding more columns (e.g. job title).
# Try adding a header row.
# Try using a different separator like '|'.
# Try reading from a file instead of a string literal.
