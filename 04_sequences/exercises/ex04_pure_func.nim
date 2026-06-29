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
var nums: array[5, int] = [42, 17, 88, 3, 65]
var nums1: seq[int] = @[42, 17, 88, 3, 65]

func average(values: openArray[int]): float =
  if values.len == 0:
    return 0.0
  var sum = 0
  for v in values:
    sum += v
  result = sum / values.len

func maxValue(values: openArray[int]): int =
  if values.len == 0:
    return 0

  var max = values[0]
  for i in 1..<values.len:
    if values[i] > max:
      max = values[i]
  result = max

echo average(nums)
echo average(nums1)
echo maxValue(nums)
echo maxValue(nums1)
