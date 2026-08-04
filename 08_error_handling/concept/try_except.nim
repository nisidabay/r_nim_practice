# nim c -r try_except.nim
# Exceptions: try/except/finally, raise, custom exceptions.

import std/strutils

# Built-in exceptions
try:
  let x = parseInt("not a number")
except ValueError:
  echo "That wasn't a number"

# Multiple except branches
try:
  let content = readFile("/nonexistent")
except IOError:
  echo "File not found"
except:
  echo "Something else happened"

# raise/re-raise
try:
  raise newException(ValueError, "Custom message")
except ValueError as e:
  echo "Caught: ", e.msg

# finally always runs
try:
  echo "Trying..."
finally:
  echo "Cleaning up (always runs)"

# ── defer ────────────────────────────────────────────────────────────
# defer runs when its enclosing scope exits — even on exceptions.

block:
  defer: echo "cleanup"                     # runs after the block
  echo "working..."                          # working...\ncleanup

# Multiple defers run in reverse order (LIFO)
block:
  defer: echo "A"
  defer: echo "B"
  defer: echo "C"
  echo "start"                               # start\nC\nB\nA

# Defer runs BEFORE the exception propagates
try:
  block:
    defer: echo "deferred cleanup"
    raise newException(ValueError, "boom")
except:
  echo "caught it"                           # deferred cleanup\ncaught it

# Common use: temp file cleanup
when false:  # change to true to run
  writeFile("tmp.txt", "data")
  defer: discard tryRemoveFile("tmp.txt")   # runs even if exception
  echo readFile("tmp.txt")

# ── Thinking in Nim ────────────────────────────
# Nim's `defer` is the standout: it always runs when its scope exits,
# even across exceptions, giving you RAII-style cleanup without bloated
# destructor ceremony. `raise newException(...)` and typed `except`
# branches keep error flow explicit while `defer` clears up after itself.
