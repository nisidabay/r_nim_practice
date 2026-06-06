# Exercise 2: Set Operations
import std/sets

var a = toHashSet([1, 2, 3, 4])
var b = toHashSet([3, 4, 5, 6])
echo "Union:        ", a + b
echo "Intersection: ", a * b
echo "Difference:   ", a - b
echo "Symmetric:    ", a -+- b
