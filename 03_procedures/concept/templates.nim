# nim c -r templates.nim
# template: like a proc but defers argument evaluation.
# template name(param: Type, ...): ReturnType =
#   body
#
# Template vs proc: the key difference
# - proc:     arguments are evaluated BEFORE the body runs
# - template: arguments are evaluated only IF the body uses them
#
# Use template when you need lazy evaluation of arguments.
# Otherwise, use proc.

proc expensiveCalculation(): string =
  echo "Computing..."
  result = "result"

template log(condition: bool, msg: string) =
  if condition:
    echo "DEBUG: ", msg

proc logProc(condition: bool, msg: string) =
  if condition:
    echo "DEBUG: ", msg

echo "--- template ---"
log(false, expensiveCalculation())

echo "--- proc ---"
logProc(false, expensiveCalculation())

# ── Thinking in Nim ────────────────────────────
# A Nim template is hygiene sugar that defers argument evaluation: arguments are
# only evaluated if the body actually uses them.
# That enables laziness an eager proc can't match — like skipping an expensive
# call inside an untaken branch.
# Procs evaluate up front; templates re-run at the call site. Reach for templates
# when you need that lazy or code-generating behavior.
