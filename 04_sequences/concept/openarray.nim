# nim c -r openarray.nim
# openArray[T] is a parameter-only type that accepts EITHER array[N,T]
# or seq[T] as an argument. Write one proc, handle both.

# ── openArray[T] — the bridge between array and seq ──────────────────

proc printAll(data: openArray[int]) =
  echo "len = ", data.len, "  items:"
  for i, x in data: echo "  [", i, "] = ", x

printAll([1, 2, 3])      # array[3, int]
printAll(@[10, 20, 30])  # seq[int]

proc avg(values: openArray[float]): float =
  for v in values: result += v
  result /= values.len.float

echo avg([1.0, 2.0, 3.0])  # 2.0
echo avg(@[4.0, 6.0])      # 5.0

# ── openArray[char] = string ─────────────────────────────────────────
# Nim strings are openArray[char] — any proc accepting openArray[char]
# also accepts string:
proc countChars(s: openArray[char]): int =
  s.len

echo countChars("hello")      # 5
echo countChars(['a', 'b'])    # 2

# ── openArray[T] generics ────────────────────────────────────────────
proc first[T](data: openArray[T]): T =
  data[0]

echo first([1, 2, 3])          # 1 (int)
echo first(@["x", "y", "z"])   # x (string)

# ── View semantics ───────────────────────────────────────────────────
# openArray is a BORROWED view — no copy, no ownership transfer.
# Use `var` parameter to modify elements through the view:
proc zeroFirst(data: var openArray[int]) =
  data[0] = 0

var myArr = [10, 20, 30]
zeroFirst(myArr)
echo myArr  # [0, 20, 30] — original was modified

# ── Slice passing ────────────────────────────────────────────────────
# Pass a slice of a seq or array as an openArray parameter:
let bigSeq = @[0, 10, 20, 30, 40]
printAll(bigSeq[1..3])       # prints only indices 1, 2, 3

let bigArray = [5, 6, 7, 8, 9]
printAll(bigArray[2..4])     # prints only indices 2, 3, 4

# ── Constraints ──────────────────────────────────────────────────────
# ⚠ Parameter-only — cannot declare variables of this type:
# var x: openArray[int]            # ❌ COMPILE ERROR

# ⚠ Cannot be a return type:
# proc make(): openArray[int] =    # ❌ COMPILE ERROR

# ⚠ No add/delete/setLen (it's a view, not a seq):
# data.add(4)                      # ❌ COMPILE ERROR
# data.delete(0)                   # ❌ COMPILE ERROR

# ── Empty openArray ──────────────────────────────────────────────────
# An empty openArray is valid — len == 0, loops run zero times:
let emptySeq: seq[int] = @[]
printAll(emptySeq)  # "len = 0  items:" and nothing else

# ── openArray vs varargs ─────────────────────────────────────────────
# varargs takes individual arguments. openArray takes a container.
# Different tools:
proc showVarargs(args: varargs[string]) =
  for a in args: echo a
showVarargs("a", "b", "c")

proc showOpenArray(args: openArray[string]) =
  for a in args: echo a
showOpenArray(@["a", "b", "c"])

# ── IndexError on empty ──────────────────────────────────────────────
# Accessing elements on an empty openArray raises IndexError at runtime:
# echo @[][0]                    # ❌ RUNTIME ERROR

# Safe pattern — check len first:
let empty: seq[int] = @[]
if empty.len > 0:
  echo empty[0]

# ── Thinking in Nim ────────────────────────────
# openArray[T] dissolves the array/seq split: one proc accepts both. It
# is a borrowed, non-owning view — no copy and no ownership transfer —
# so pass array, seq, string, or a slice and the compiler adapts.
