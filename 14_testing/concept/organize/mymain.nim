# Module: mymain — imports mymath + myformat, exports testable procs

import mymath, myformat

proc processInput*(a, b: int, op: string): string =
  ## Returns string result of operation. "bad" on unknown op.
  case op:
  of "add": $add(a, b)
  of "subtract": $subtract(a, b)
  of "multiply": $multiply(a, b)
  else: "error: unknown operation '" & op & "'"

proc formatOutput*(procResult: string): string =
  ## Format a result string for display.
  padCenter(procResult, 20)
