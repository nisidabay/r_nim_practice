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
