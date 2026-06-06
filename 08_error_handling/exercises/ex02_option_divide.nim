# Exercise 2: Option Pipeline
import std/options

proc safeDivide(a, b: float): Option[float] =
  if b == 0.0: none[float]()
  else: some(a / b)

let r1 = safeDivide(10.0, 2.0)
echo r1.isSome, " ", r1.get()
let r2 = safeDivide(10.0, 0.0)
echo r2.isSome
