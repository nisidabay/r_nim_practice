# You call `len([1, 2, 3])` and `len(["a", "b"])` — same proc, different types.
# Generics let you write one piece of code that works with ANY type.
# The type variable `T` is a placeholder filled in at compile time.

proc echoType[T](x: T): T =
  ## Identity function — works for int, string, float, anything.
  result = x

doAssert echoType(42) == 42
doAssert echoType("hello") == "hello"
doAssert echoType(3.14) == 3.14

# ── Multiple type parameters ──────────────────────────────────────────

proc pair[A, B](a: A, b: B): (A, B) = (a, b)

let p = pair(1, "one")         # (int, string)
doAssert p == (1, "one")

# ── Generic types ─────────────────────────────────────────────────────

type
  Box[T] = object
    val: T

let intBox = Box[int](val: 10)
let strBox = Box[string](val: "hi")

doAssert intBox.val == 10
doAssert strBox.val == "hi"

# Every type gets its OWN Box — Box[int] and Box[string] are distinct types.

# ── Type constraints: restrict what T can be ──────────────────────────

proc doubleIt[T: SomeNumber](x: T): T =
  ## SomeNumber = int | float | uint | etc. Not strings, not seqs.
  x + x

doAssert doubleIt(5) == 10
doAssert doubleIt(2.5) == 5.0
# doubleIt("hi")   # compile ERROR: string is not SomeNumber

proc sumInts[T: SomeInteger](a, b: T): T =
  a + b

doAssert sumInts(3, 4) == 7
# sumInts(2.5, 1.5)   # compile ERROR: float is not SomeInteger

# ── Union syntax ──────────────────────────────────────────────────────

proc flex[T: int or float](x: T): T = x * 2

doAssert flex(10) == 20
doAssert flex(1.5) == 3.0
# flex("hi")   # compile ERROR — string is not int or float

# Constrained generics give BETTER error messages. The compiler tells you
# exactly which type class was violated, not just "type mismatch".

# ── You've been using generics all course ─────────────────────────────

# seq[T]     → Module 04   HashSet[T] → Module 06   Option[T] → Module 08

# ── How it works ──────────────────────────────────────────────────────

# Monomorphization (like C++ templates): one copy per concrete type.
# Zero runtime overhead, slightly larger binaries.
#
# For constraints, Nim provides: SomeNumber, SomeInteger, SomeOrdinal,
# SomeFloat, and more in std/typeinfo.
