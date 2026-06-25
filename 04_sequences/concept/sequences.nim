# nim c -r sequences.nim
# seq[T] is Nim's dynamic array — growable, sliceable, iterable.
# NOTE: That [T] means "generic" — seq works with any type.
# You write seq[int], seq[string], seq[YourType]. See Module 09.

var nums: seq[int] = @[]        # empty sequence
nums.add(1)
nums.add(2)
nums.add(3)
echo nums                         # @[1, 2, 3]

# Literal with @
var names = @["Carlos", "Ana", "Luis"]
echo names[0]                     # Carlos
echo names[^1]                    # Luis — indexing from the end

# Slicing: names[start ..< end]
echo names[0 ..< 2]               # @["Carlos", "Ana"]

# len, setLen
echo "len = ", names.len
names.setLen(1)
echo names                        # @["Carlos"]

# Multi-dimensional
var grid: seq[seq[int]] = @[@[1, 2], @[3, 4]]
echo grid[1][0]                   # 3

# Insert and delete
var items = @["a", "b", "d"]
items.insert("c", 2)              # @["a", "b", "c", "d"]
items.delete(0)                   # @["b", "c", "d"]
echo items

# concat with &
echo @[1, 2] & @[3, 4]            # @[1, 2, 3, 4]
