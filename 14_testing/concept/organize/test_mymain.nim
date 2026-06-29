# nim c -r test_mymain.nim
# Test suite for mymain module — integration tests across mymath + myformat.

import std/unittest
import std/strutils
import mymain

suite "mymain":
  test "processInput — add":
    check processInput(2, 3, "add") == "5"

  test "processInput — subtract":
    check processInput(10, 4, "subtract") == "6"

  test "processInput — multiply":
    check processInput(3, 7, "multiply") == "21"

  test "processInput — unknown operation":
    check processInput(1, 2, "bad") == "error: unknown operation 'bad'"

  test "formatOutput — pads result":
    let result = formatOutput("42")
    check result.len == 20
    check "42" in result
