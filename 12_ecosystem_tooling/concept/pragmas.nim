# Pragmas — compiler directives for optimization, compile-time, and API control
#   nim c -r pragmas.nim

# ── inline: request the compiler inline a proc ─────────────────────────

{.push inline.}

proc double(x: int): int {.inline.} =
  ## Doubles a number — inlined to avoid call overhead
  x * 2

{.pop.}

echo "double(21) = ", double(21)

# ── push/pop: apply pragmas to a block of procs ────────────────────────

{.push compileTime.}

proc square(x: int): int = x * x
proc cube(x: int): int = x * x * x

{.pop.}

echo "square(5) = ", square(5)
echo "cube(3) = ", cube(3)

# ── compileTime: run code at compile time ───────────────────────────────

proc compileTimeValue(): int {.compileTime.} =
  ## Evaluated at compile time, not runtime
  42

const resolved = compileTimeValue()
echo "Compile-time constant: ", resolved

# ── used: suppress unused warning ──────────────────────────────────────

proc onStartup() {.used.} =
  ## Registered as a callback but never called directly
  echo "Startup routine (registered via .used)"

onStartup()  # actually call it to show it works

# ── deprecated: mark a symbol as deprecated ────────────────────────────

proc oldFunction() {.used, deprecated: "use newFunction instead".} =
  echo "This is old"

proc newFunction() = echo "This is new"

newFunction()
# oldFunction()  # would produce a deprecation warning

# ── Thinking in Nim ────────────────────────────
# Pragmas are the primary way Nim talks to its own compiler — written as
# {.name.} blocks right next to the code they affect. With push/pop you
# batch pragmas over a whole region, and compileTime lets you evaluate
# procs at build time and fold the results into consts, not just hints.