# Templates inject code at the call site (like hygienic C macros).
# Macros manipulate the AST at compile time (like typed Lisp macros).

import macros

# ── Template: arguments are NOT evaluated before insertion ────────────
# This avoids evaluating expensive expressions in dead code paths.

proc expensiveCalc(): int =
  echo "EXPENSIVE: this runs!"
  42

template debugLog(msg: string, value: int) =
  when defined(debug):
    echo "[DEBUG] ", msg, ": ", value

debugLog("computation", expensiveCalc())
# In normal debug mode, expensiveCalc() runs and prints.
# Compile with -d:release — expensiveCalc() never runs!


# ── Template that repeats code: evaluate the body twice ───────────────

template twice(expr: untyped): untyped =
  expr; expr

var count = 0
twice: count += 1
echo count   # 2 — body was injected twice


# ── Macro: inspect AST nodes and generate new code ────────────────────

macro debugVar(v: untyped): untyped =
  let varName = repr(v)
  result = quote do:
    echo `varName`, " = ", `v`

var health = 100
var mana = 50
debugVar(health)   # prints: health = 100
debugVar(mana)     # prints: mana = 50


# ── Macro that defines routes (DSL-like syntax) ───────────────────────

macro route(path: static[string], body: untyped): untyped =
  result = quote do:
    echo "Registered route: ", `path`
    `body`

route("/users"):
  echo "Handling GET /users"

route("/health"):
  echo "OK"


# ── When to use what ──────────────────────────────────────────────────
# proc:      normal function — arguments evaluated before call
# template:  inject code without evaluating arguments — inline expansion
# macro:     inspect/modify/generate AST — DSLs, ORMs, code generators
