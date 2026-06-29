# nim c -r test_mymath.nim
# Test suite for mymath module.

import std/unittest
import mymath

suite "mymath":
  test "add — positive numbers":
    check add(2, 3) == 5
    check add(10, 20) == 30

  test "add — negative numbers":
    check add(-2, -3) == -5
    check add(-10, 5) == -5

  test "add — zero":
    check add(0, 0) == 0
    check add(5, 0) == 5
    check add(0, 7) == 7

  test "subtract — basics":
    check subtract(10, 3) == 7
    check subtract(0, 5) == -5
    check subtract(-3, -3) == 0

  test "multiply — basics":
    check multiply(3, 4) == 12
    check multiply(-2, 5) == -10
    check multiply(0, 100) == 0
    check multiply(7, 0) == 0
