# formatter.nim — Output formatting using math, algorithm, and arrays
#   import formatter
#
# Provides formatTable and fmtStat for displaying system info data.

import std/[math, algorithm, strutils, json, strformat]

proc formatTable*[T](data: openArray[T]): string =
  ## Format a sequence as a sorted, indented table.
  ## Works with any type that has `$`.
  ## Sorts data alphabetically before display.
  var sorted: seq[T]
  for item in data:
    sorted.add(item)
  sorted.sort()
  result = "  " & sorted.join("\n  ")

proc fmtStat*(values: openArray[float]): string =
  ## Compute and format statistics: mean, min, max.
  let
    total = sum(values)
    count = values.len.float
    avg = total / count
    lo = min(values)
    hi = max(values)
  result = &"mean: {avg:.2f}, min: {lo:.2f}, max: {hi:.2f}"

proc fmtJson*(node: JsonNode): string =
  ## Format a JsonNode as indented JSON with a trailing newline.
  result = node.pretty() & "\n"

when isMainModule:
  # Demo
  let scores = [42.5, 88.0, 17.3, 63.1, 5.0]
  echo "Statistics: ", fmtStat(scores)
  echo "Values:\n", formatTable(@["gamma", "alpha", "beta"])