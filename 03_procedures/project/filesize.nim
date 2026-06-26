# nim c -r filesize.nim <num1> <op> <num2>
# CLI calculator using procs, UFCS, and control flow (Modules 01-03).
import std/[os, strutils]

# parseFloat covered in concept/input.nim, quit(1) in concept/cliargs.nim (Section 01).

proc add(a, b: float): float = a + b
proc sub(a, b: float): float = a - b
proc mul(a, b: float): float = a * b
proc divide(a, b: float): float = a / b

proc power(a, b: float): float =
  result = 1.0
  for _ in 1 .. int(b):
    result *= a

proc calculate(a: float, op: string, b: float): string =
  case op
  of "+": result = $(a.add(b))
  of "-": result = $(a.sub(b))
  of "*": result = $(a.mul(b))
  of "/":
    if b == 0.0: result = "Error: division by zero"
    else: result = $(a.divide(b))
  of "^": result = $(a.power(b))
  else: result = "Error: unknown operator '" & op & "'"

if paramCount() != 3:
  echo "Usage: filesize <num1> <op> <num2>"
  echo "Operators: + - * / ^"
  quit(1)

let a = parseFloat(paramStr(1))
let op = paramStr(2)
let b = parseFloat(paramStr(3))

echo paramStr(1), " ", op, " ", paramStr(3), " = ", calculate(a, op, b)
