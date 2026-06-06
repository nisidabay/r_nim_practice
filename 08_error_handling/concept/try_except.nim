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
