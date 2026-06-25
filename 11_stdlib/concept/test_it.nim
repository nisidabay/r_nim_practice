# 11 Stdlib — Test It
# Parse JSON, sort by a field, print a summary.

import std/[json, algorithm]

let rawJson = """
[
  {"name": "Alice", "score": 95},
  {"name": "Bob", "score": 82},
  {"name": "Charlie", "score": 91},
  {"name": "Diana", "score": 78}
]
"""

var data = parseJson(rawJson).getElems()

# Sort by score descending
data.sort do (a, b: JsonNode) -> int:
  cmp(b["score"].getInt(), a["score"].getInt())

echo "Leaderboard:"
for entry in data:
  echo "  ", entry["name"].getStr(), " — ", entry["score"].getInt()

# Summary stats
var total = 0
for entry in data:
  total += entry["score"].getInt()
let avg = float(total) / data.len.float
echo "\nAverage score: ", avg

# Try adding more fields (e.g. "grade").
# Try sorting by name alphabetically instead.
# Try parsing JSON from a file.
