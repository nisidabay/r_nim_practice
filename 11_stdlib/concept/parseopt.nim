# std/parseopt — command-line argument parsing
#   nim c -r concept/parseopt.nim --os --math
#
# The idiomatic way to parse CLI args in Nim. More flexible than paramStr.

import std/parseopt

# ── Manual parsing with next() ──────────────────────────────────────────

var p = initOptParser()          # reads command-line args

while true:
  p.next()
  case p.kind
  of cmdEnd: break
  of cmdShortOption:
    echo "short flag: -", p.key, " = ", p.val
  of cmdLongOption:
    echo "long flag:  --", p.key, " = ", p.val
  of cmdArgument:
    echo "arg:        ", p.val

# ── Shortcut: getopt template ───────────────────────────────────────────

# For most tools, Nim provides a cleaner pattern using getopt.
# It's a template that wraps the next() loop:

when false:  # set to true to test with: nim c -r parseopt.nim -v --file data.txt
  var verbose = false
  var filename = ""

  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      echo "positional: ", val
    of cmdLongOption:
      case key
      of "verbose", "v": verbose = true
      of "file", "f": filename = val
      else:
        echo "unknown: --", key
        quit(1)
    of cmdShortOption:
      case key
      of "v": verbose = true
      of "f": filename = val
      else:
        echo "unknown: -", key
        quit(1)
    of cmdEnd: discard

  echo "verbose=", verbose, " file=", filename

echo "\nRun with: nim c -r concept/parseopt.nim --os --math"
echo "Or:       nim c -r concept/parseopt.nim -v --file test.txt"
