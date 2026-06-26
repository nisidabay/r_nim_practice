# nim c -r ex04_pure_func.nim
# Exercise: which of these can be `func`?
# A func cannot: echo, write files, modify globals, or mutate params.
# Change the ones that CAN be func. Leave the others as proc.

# ── Can this be func? ───────────────────────────────────────────────────
proc average(values: seq[float]): float =
  ## Compute mean. No side effects.
  var sum = 0.0
  for v in values:
    sum += v
  result = sum / values.len.float

# ── Can this be func? ───────────────────────────────────────────────────
proc report(values: seq[float]) =
  ## Print stats to stdout.
  echo "values: ", values.len
  echo "average: ", average(values)

# ── Can this be func? ───────────────────────────────────────────────────
proc maxValue(values: seq[float]): float =
  ## Find maximum. No side effects.
  result = values[0]
  for v in values:
    if v > result:
      result = v

# ── Tests ───────────────────────────────────────────────────────────────
# Uncomment when you've made your changes:
# assert abs(average(@[1.0, 2.0, 3.0]) - 2.0) < 1e-10
# assert abs(maxValue(@[1.0, 5.0, 3.0]) - 5.0) < 1e-10
# echo "All checks passed (if you uncommented the tests)"
