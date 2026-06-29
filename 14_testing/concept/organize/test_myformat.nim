# nim c -r test_myformat.nim
# Test suite for myformat module.

import std/unittest
import myformat

suite "myformat":
  test "padCenter — even width":
    check padCenter("Hi", 6) == "  Hi  "
    check padCenter("AB", 4) == " AB "

  test "padCenter — odd width":
    check padCenter("Hi", 7) == "  Hi   "
    check padCenter("X", 5) == "  X  "

  test "padCenter — wider than width":
    check padCenter("HelloWorld", 5) == "HelloWorld"

  test "truncateLeft — short string, no truncation":
    check truncateLeft("abc", 5) == "abc"
    check truncateLeft("hi", 2) == "hi"

  test "truncateLeft — exact length, no truncation":
    check truncateLeft("nim", 3) == "nim"

  test "truncateLeft — long string, truncated":
    check truncateLeft("hello world", 5) == "…world"
    check truncateLeft("abcdef", 3) == "…def"
