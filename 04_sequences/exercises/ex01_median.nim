# Exercise 1: Random Median
import std/random, std/algorithm
# NOTE: std/random is covered in Module 11 (stdlib).
randomize()

var nums = newSeq[int](5)
for i in 0..<5: nums[i] = rand(1..100)
nums.sort()
echo nums
echo "Median: ", nums[2]
