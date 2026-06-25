# nim c -r iterators.nim
# Iterators yield values one at a time — they don't build the whole list in
# memory.
#
# ── Syntax ───────────────────────────────────────────────────────────
#   iterator name(param: Type, ...): YieldedType = body
#   yield value   # emit one value and suspend execution
#
# Same syntax as proc/func (Module 03) but uses `yield` instead of `return`.
# Iterators can only be called inside a for loop.
# ─────────────────────────────────────────────────────────────────────

# Simple iterator
# Iterators vs ranges:
#   for i in 1..3       — uses a range (built-in), simple, no custom logic
#   for x in countTo(3) — uses a custom iterator with yield, you control what
#                          happens between yields, and the values don't all exist
#                          in memory at once
iterator countTo(n: int): int =
  var i = 1
  while i <= n:
    yield i
    inc i

for x in countTo(3):
  echo x

# ── Pragmas: what are those {.xxx.} things? ──────────────────────────
# Pragmas are compiler directives — annotations that change how Nim
# compiles or optimizes your code. They go inside {. .} brackets.
#
# Common uses:
#   {.inline.}    — copy this code directly at each call site (speed)
#   {.discardable.} — don't warn if return value is ignored
#   {.deprecated.}  — mark something as outdated
#   {.used.}      — keep a symbol even if it looks unused
#
# You'll see more as we go. Module 12 covers pragmas in detail.
# ─────────────────────────────────────────────────────────────────────
# Inline iterator (inlined at compile time for speed)
iterator oddNumbers(limit: int): int {.inline.} =
  var i = 1
  while i <= limit:
    yield i
    i += 2

echo "---"
for x in oddNumbers(9):
  echo x
