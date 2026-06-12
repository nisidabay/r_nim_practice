# helper.nim — imported by modules.nim to demonstrate import/include mechanics
# This file exports a single proc.

proc greet*(name: string): string =
  ## Return a greeting — the `*` makes this symbol exported.
  "Hello, " & name & "!"