# nim c -r cliargs.nim
# paramCount / paramStr: read command-line arguments (like ARGV in Ruby).

import std/os

# paramCount(): number of arguments passed (excluding program name)
# paramStr(i): i-th argument (0 = program name, 1 = first arg, ...)
echo "Program: ", paramStr(0)
echo "Arg count: ", paramCount()

# Guard: check required arguments before using them
if paramCount() < 1:
  echo "Usage: cliargs <name> [--verbose]"
  quit(1)  # exit with error code (0 = success, non-zero = error)

let name = paramStr(1)
echo "Hello, ", name, "!"

# Loop over all arguments
for i in 1 .. paramCount():
  echo "  arg ", i, ": ", paramStr(i)

# ── Thinking in Nim ────────────────────────────
# Command-line access lives in std/os: paramCount() and paramStr(i) read args
# directly, with the program name at index 0.
# Combined with the `quit(code)` exit call and `case`/`for` over the args,
# Nim gives you the whole argv dance with no framework, just the standard library.
