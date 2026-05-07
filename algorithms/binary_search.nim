# Binary search function in Nim

proc binarySearch(data: seq[int], target: int): int =
  var left, right: int
  left = 0
  right = data.len - 1

  while left <= right:
    var mid = (left + right) div 2
    if data[mid] == target:
      return mid
    elif data[mid] < target:
      left = mid + 1
    else:
      right = mid - 1

  return -1

# Example usage
var sortedata = @[1, 3, 5, 7, 9, 11, 13]
let result = binarySearch(sortedata, 7)

if result != -1:
  echo "7 found at index: " & $result
else:
  echo "Number not found"

# Test with a value not in data
let result2 = binarySearch(sortedata, 6)

if result2 != -1:
  echo "6 found at index: " & $result2
else:
  echo "Number not found"

