# How do I manage raw memory? — alloc, dealloc, realloc
#   nim c -r raw_memory.nim
#
# `alloc`/`alloc0`/`dealloc`/`realloc` give you UNTRACED heap memory —
# the GC does NOT watch it. You are the owner. You decide when it dies.
#
# These are the FFI and low-level data-structure primitives. Source of
# leaks if you forget to free.

# ── alloc0: zeroed memory ───────────────────────────────────────────────

let count = 5
var buf = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * count))
# alloc0 fills with zeroes. alloc does NOT initialize — reads are garbage.

for i in 0 ..< count:
  buf[i] = (i + 1) * 2
for i in 0 ..< count:
  echo "buf[", i, "] = ", buf[i]      # 2, 4, 6, 8, 10

# ── realloc: grow without copying by hand ────────────────────────────────

buf = cast[ptr UncheckedArray[int]](realloc(buf, sizeof(int) * (count + 2)))
buf[count] = 100
buf[count + 1] = 200
echo "grown: buf[5] = ", buf[5], ", buf[6] = ", buf[6]

# ── dealloc: release exactly what you allocated ─────────────────────────

dealloc(buf)                    # REQUIRED — the GC won't do it for you
# After dealloc, buf is dangling. Do not read or write it again.

# ── sizeof: how big is one element? ─────────────────────────────────────

echo "sizeof(int)   = ", sizeof(int)
echo "sizeof(float) = ", sizeof(float)

# ── create: typed allocation without casts ──────────────────────────────

var arr = create(int, 3)        # allocates 3 contiguous ints, returns ptr int
let cells = cast[ptr UncheckedArray[int]](arr)   # cast to index it
cells[0] = 11
cells[1] = 22
cells[2] = 33
echo "create: ", cells[0], ", ", cells[1], ", ", cells[2]

# resize grows in place (new pointer); dealloc the RESULT, not the old one
let grownPtr = resize(cast[ptr int](arr), 5)
let grown = cast[ptr UncheckedArray[int]](grownPtr)
grown[3] = 44
grown[4] = 55
echo "resize: ", grown[3], ", ", grown[4]
dealloc(grownPtr)               # free the reallocated block

# ── The ownership discipline that prevents leaks ────────────────────────
#
# Every alloc/alloc0/create needs a matching dealloc on EVERY exit path.
# Prefer ref T / seq / string for normal code. Reach for raw memory only
# at the boundary where you must control layout or interop with C.

# ── Thinking in Nim ────────────────────────────
# Raw memory in Nim is opt-in, not the default: `alloc`/`alloc0`/
# `dealloc`/`realloc`/`create`/`resize` hand you untraced bytes that the
# GC never sees — so freeing is YOUR job and forgetting is a leak. Sizes
# come from `sizeof(T)`, and `cast[ptr UncheckedArray[T]]` gives it a typed
# face. `alloc0` zero-initializes; `alloc` is faster but garbage-until-you-
# write. Use raw memory only when layout or C interop demands it, and pair
# every allocation with a dealloc.
