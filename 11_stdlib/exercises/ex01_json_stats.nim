# ex01_json_stats.nim — Parse JSON, compute stats with std/math
#   nim c -r exercises/ex01_json_stats.nim
#
# Reads data.json, computes mean/min/max of the numeric values.

import std/[json, math, os]

let dataPath = currentSourcePath().parentDir() / "data" / "data.json"
let raw = readFile(dataPath)
let arr = parseJson(raw)

# Convert JsonNode array to seq[float]
var values: seq[float] = @[]
for item in arr:
  values.add(item.getFloat())

# Compute stats using std/math
let
  total = sum(values)
  count = values.len.float
  mean = total / count
  minimum = min(values)
  maximum = max(values)

echo "Data: ", values
echo "Mean: ", mean
echo "Min:  ", minimum
echo "Max:  ", maximum

# Verify
assert mean == 3.0
assert minimum == 1.0
assert maximum == 5.0
echo "All assertions passed."