# Exercise 1: Median
var nums: array[5, int] = [42, 17, 88, 3, 65]

# Manual insertion sort (loops only — taught in Sections 01-04)
for i in 1 ..< nums.len:
  let key = nums[i]
  var j = i - 1
  while j >= 0 and nums[j] > key:
    nums[j + 1] = nums[j]
    dec j
  nums[j + 1] = key

echo "Sorted: ", nums
echo "Median: ", nums[2]
