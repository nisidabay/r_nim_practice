# array[N, T] — fixed-size, stack-allocated, compile-time bounds checked
#   nim c -r arrays.nim

# ── Declaration ─────────────────────────────────────────────────────────

var
  a: array[5, int]        # 5 elements, zero-initialized: [0, 0, 0, 0, 0]
  b = [10, 20, 30]        # inferred: array[3, int]

echo "zero-init a: ", a
echo "inferred b: ", b
echo "len(a) = ", a.len                      # 5
b[1] = 99
echo "b after mut: ", b                      # [10, 99, 30]

# ── Compile-time bounds ─────────────────────────────────────────────────

echo "b[0] = ", b[0]                         # 10
echo "b[2] = ", b[2]                         # 30
# echo b[3]  # compile ERROR — index 3 is out of bounds for array[3, int]

# Seq access is checked at RUNTIME (IndexError exception).
echo "seq out-of-bounds raises at runtime, array at compile time"

# ── Array vs seq — tradeoffs ────────────────────────────────────────────
#
# array[N, T]          | seq[T]
#──────────────────────|──────────────────────────────
# Stack-allocated      | Heap-allocated
# Fixed size at compile| Dynamic — add/remove at runtime
# No allocation cost   | May reallocate on growth
# Best for known limits| Best for variable-length data

# ── Multi-dimensional ───────────────────────────────────────────────────

var matrix: array[3, array[4, int]]          # 3 rows × 4 cols
for i in 0..2:
  for j in 0..3:
    matrix[i][j] = i * 4 + j

echo "matrix[0][2] = ", matrix[0][2]         # 2
echo "matrix[2][3] = ", matrix[2][3]         # 11
echo "full matrix: "
for row in matrix:
  echo "  ", row

# ── Manual sort on arrays ───────────────────────────────────────────────

var vals: array[6, int] = [9, 4, 7, 1, 5, 3]
for i in 0 ..< vals.len:
  for j in (i + 1) ..< vals.len:
    if vals[j] < vals[i]:
      swap(vals[i], vals[j])
echo "sorted vals: ", vals                    # [1, 3, 4, 5, 7, 9]

# Convert to seq when you need dynamic size
let seqVals = @vals
echo "as seq: ", seqVals

# ── openArray[T] — bridge between array and seq ─────────────────────────
# openArray[T] is a parameter-only type that accepts both array[N,T]
# and seq[T]. Write one proc, handle both.

proc printAll(data: openArray[int]) =
  echo "len = ", data.len, "  items:"
  for i, x in data: echo "  [", i, "] = ", x

printAll([1, 2, 3])      # array[3, int]
printAll(@[10, 20, 30])  # seq[int]

proc avg(values: openArray[float]): float =
  for v in values: result += v
  result /= values.len.float

echo avg([1.0, 2.0, 3.0])   # 2.0
echo avg(@[4.0, 6.0])       # 5.0

# Empty openArray is valid (len == 0)
let emptySeq: seq[int] = @[]
printAll(emptySeq)

# ⚠ Parameter-only — cannot declare variables of this type
# var x: openArray[int]  # ❌ COMPILE ERROR

# openArray does NOT support add/delete/setLen (it's a view, not a seq)
# data.add(4)     # ❌ COMPILE ERROR
# data.delete(0)  # ❌ COMPILE ERROR
# data.setLen(5)  # ❌ COMPILE ERROR

# Indexing an empty openArray raises IndexError at runtime
# echo printAll(@[])  # fine (len == 0, loop doesn't run)
# echo @[][0]         # ❌ RUNTIME ERROR: index out of bounds
