# cli_handler.nim — Command-line argument handling for the modular CLI tool
# Uses std/os for parameter parsing.

import std/[os, strutils]

type
  CliOptions* = object
    minVal*: int
    showJson*: bool

proc parseArgs*(): CliOptions =
  ## Parse CLI arguments. Supports --min=N and --json flags.
  result = CliOptions(minVal: 0, showJson: false)
  var i = 1
  while i <= paramCount():
    let arg = paramStr(i)
    if arg == "--json":
      result.showJson = true
    elif arg.startsWith("--min="):
      result.minVal = parseInt(arg[6..^1])
    elif arg == "--help" or arg == "-h":
      echo "Usage: main.nim [--min=N] [--json]"
      echo "  --min=N    Minimum value filter (default: 0)"
      echo "  --json     Output as JSON"
      quit(0)
    i += 1