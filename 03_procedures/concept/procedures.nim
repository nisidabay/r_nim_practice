# nim c -r procedures.nim
# procs: no parens if no args, explicit return type, `result` is the default return variable.

proc hello() =
  echo "Hello from a proc"

hello()

# With parameters and return type
proc add(a, b: int): int =
  return a + b                     # explicit return

echo add(3, 4)

# `result` is an implicit return variable (no `return` needed)
proc multiply(a, b: int): int =
  result = a * b

echo multiply(5, 6)

# Default values
proc greet(name: string = "Carlos"): string =
  result = "Hola, " & name

echo greet()
echo greet("Ana")

# Discardable return value
proc maybe(): int {.discardable.} =
  return 42

maybe()                           # no error even though we ignore result
