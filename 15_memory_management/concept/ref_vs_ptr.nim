# How do I point at data in Nim? — ref (GC) vs ptr (raw)
#   nim c -r ref_vs_ptr.nim
#
# Nim has TWO pointer kinds:
#   ref T  — "traced" reference, GC-managed. Safe default.
#   ptr T  — "untraced" raw pointer, manual memory. Low-level, careful.

# ── ref T: the safe reference ───────────────────────────────────────────

type Box = ref object
  value: int

var b = Box(value: 7)
echo "b.value = ", b.value        # `.` dereferences implicitly
echo "b[]     = ", b[]            # explicit deref with []

# `.` and `[]` both reach the pointed-to data. You never write `->`.

# ── ptr T: the raw pointer ──────────────────────────────────────────────

var n = 10
let p: ptr int = addr(n)          # address of a mutable variable
echo "p[] = ", p[]                # read through the pointer
p[] = 99                          # write through the pointer
echo "n is now ", n               # 99 — p and n share memory

# addr() only accepts mutable l-values. Fine here: `n` is `var`.
# let p2 = addr(...)  # compile error if target is a `let`

# ── nil: a pointer to nothing ───────────────────────────────────────────

var nothing: ref Box = nil
echo "is nothing? ", nothing == nil   # true

# Accessing `.value` on a nil ref raises NilAccessDefect at runtime.
# Guard before use, or use Option[T] when "no value" is a real state.

# ── unsafeAddr: the escape hatch ────────────────────────────────────────

let c = 5                            # a `let` — immutable binding
let cp: ptr int = unsafeAddr(c)      # unsafeAddr bypasses the let rule
echo "cp[] = ", cp[]
# unsafeAddr is a last resort for C interop. Prefer mutable vars + addr().

# ── Rule of thumb ───────────────────────────────────────────────────────
# Reach for `ref` unless you are at the C / allocator boundary.
# Raw `ptr` is for low-level memory, FFI, and performance-critical code.
# Every `ptr` you hand out is a promise you know how long the data lives.

# ── Thinking in Nim ────────────────────────────
# Nim exposes BOTH pointer models: `ref` is GC-managed (safe, automatic,
# the default) while `ptr` is a bare address you manage yourself (fast,
# dangerous). The same `[]` and `.` deref syntax works for both, so the
# difference is ownership: `ref` frees itself; `ptr` stays until *you*
# deallocate it — or leaks.
