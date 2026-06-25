# nim c -r stats.nim <number> <number> ...
# Compute basic statistics from command-line numbers.
import std/[os, strutils]

if paramCount() == 0:
  echo "Usage: stats <numbers...>"
  echo "  e.g. stats 1 2 3 4 5"
  quit(1)

var nums: seq[float] = @[]
for i in 1..paramCount():
  nums.add(parseFloat(paramStr(i)))

# Manual insertion sort (loops only — taught in Sections 01-04)
for i in 1 ..< nums.len:
  let key = nums[i]
  var j = i - 1
  while j >= 0 and nums[j] > key:
    nums[j + 1] = nums[j]
    dec j
  nums[j + 1] = key

let n = nums.len
var sum: float = 0.0
for v in nums: sum += v
let mean = sum / n.float
let median = if n mod 2 == 1: nums[n div 2]
             else: (nums[n div 2 - 1] + nums[n div 2]) / 2.0
let minimum = nums[0]
let maximum = nums[^1]

echo "Count:   ", n
echo "Min:     ", minimum
echo "Max:     ", maximum
echo "Mean:    ", mean
echo "Median:  ", median
echo "Sum:     ", sum
