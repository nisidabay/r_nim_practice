# nim c -r procedures.nim
# procs: no parens if no args, explicit return type, `result` is the default
# return variable.
#
# ── Syntax ───────────────────────────────────────────────────────────
#   proc name(param: Type, ...): ReturnType = body
#   func name(param: Type, ...): ReturnType = body   # no side effects
#
#   name       = identifier
#   param      = parameter in "name: Type" form
#   ReturnType = type of the return value (optional — omit for void)
#   body       = expression or indented block
#   result     = implicit variable that holds the return value
#
# Same syntax applies to iterators (Module 02) and methods (Module 12).
# ─────────────────────────────────────────────────────────────────────

proc hello() =
  echo "Hello from a proc"

hello()

# With parameters and return type.
# The body can be a single expression — Nim returns the last expression
# implicitly. Use `return` for explicit early returns.
proc add(a, b: int): int = a + b

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
# {.discardable.} is another pragma (see iterators.nim for what pragmas are).
# It suppresses the warning when a return value is ignored. Handy for
# function-like procs you call for their side effects, not their result.
proc maybe(): int {.discardable.} =
  return 42

maybe() # no error even though we ignore result
echo maybe() # 42

# ── discard statement ────────────────────────────────────────────────
proc notify(msg: string): int = msg.len
discard notify("hi")  # without `discard`, Nim warns "return value ignored"

# ── func: a proc with NO side effects ─────────────────────────────────
# `func` is like `proc` but the compiler ENFORCES purity at compile time.
# A func CANNOT:
#   • echo, writeFile, or any I/O
#   • modify global variables
#   • mutate its arguments (unless they're ref types)
# Use func when the only thing that matters is the return value.
#
# This is Nim's embrace of functional programming — pure functions are
# easier to test, reason about, and optimise.
#
# ── proc (can do anything)       ── func (pure computation only)
proc greetAndLog(name: string): string =
  echo "logging: " & name # ⚠ side effect
  result = "Hello, " & name

echo greetAndLog("Ana")

when false: # change false → true to see the compile error
  func greetPure(name: string): string =
    echo "nope"                    # ❌ COMPILE ERROR: 'echo' has side effects
    result = "Hello, " & name

# ── Same result, different guarantee ───────────────────────────────────
func double(n: int): int = n * 2 # pure: same input → same output, always
proc doubleAndPrint(n: int): int =
  echo "doubling ", n # side effect
  result = n * 2

echo double(21) # 42
echo doubleAndPrint(21) # 42 (but also prints)

# ── varargs[T] ────────────────────────────────────────────────────────
# varargs[T] accepts zero or more arguments; inside the proc it
# behaves like a seq[T]. Must be the LAST parameter.

proc log(msgs: varargs[string]) =
  echo "got ", msgs.len, " message(s)"
  for m in msgs: echo "  ", m

log()                    # got 0 message(s)
log("hello")             # got 1 message(s)
log("a", "b", "c")       # got 3 message(s)

# varargs must be the LAST parameter (compiler-enforced)
proc format(prefix: string, values: varargs[int]): string =
  result = prefix & ": "
  for v in values: result.add($v & " ")

echo format("nums", 1, 2, 3)   # "nums: 1 2 3 "

when false:  # change to true to see the compile error
  proc bad(pos: varargs[int], label: string) = discard
  # ❌ COMPILE ERROR: varargs must be the LAST parameter

# Real-world usage: echo uses varargs[typed, `$`] internally to
# accept any type and convert each argument via `$` to string.
