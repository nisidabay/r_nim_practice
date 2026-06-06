# nim c -r stats.nim <number> <number> ...
# Compute basic statistics from command-line numbers.
import std/[algorithm, os, strutils, sequtils]

if paramCount() == 0:
  echo "Usage: stats <numbers...>"
  echo "  e.g. stats 1 2 3 4 5"
  quit(1)

var nums: seq[float] = @[]
for i in 1..paramCount():
  nums.add(parseFloat(paramStr(i)))

nums.sort()

let n = nums.len
let sum = nums.foldl(a + b)
let mean = sum / n.float
let median = if n mod 2 == 1: nums[n div 2]
             else: (nums[n div 2 - 1] + nums[n div 2]) / 2.0
let minimum = nums[0]
let maximum = nums[^1]

echo "Count:   ", n
echo "Min:     ", minimum.formatBiggestFloat(ffDecimal)
echo "Max:     ", maximum.formatBiggestFloat(ffDecimal)
echo "Mean:    ", mean.formatBiggestFloat(ffDecimal)
echo "Median:  ", median.formatBiggestFloat(ffDecimal)
echo "Sum:     ", sum.formatBiggestFloat(ffDecimal)
