# 15 Memory Management — ref vs ptr, Raw Memory, and Ownership

## Quick Start

```bash
nim c -r 15_memory_management/concept/ref_vs_ptr.nim
nim c -r 15_memory_management/concept/raw_memory.nim
nim c -r 15_memory_management/concept/ownership.nim
nim c -r 15_memory_management/concept/casting.nim
nim c -r 15_memory_management/concept/test_it.nim
nim c -r 15_memory_management/exercises/ex01_ptr_swap.nim
nim c -r 15_memory_management/project/linked_list.nim
```

## Learning Path

| File | Concept | Key Pattern |
|------|---------|-------------|
| `ref_vs_ptr.nim` | ref (GC-managed) vs ptr (raw): deref with `.` and `[]`, nil, unsafeAddr | `type Box = ref object; value: int`; `b.value` / `b[]`; `let p: ptr int = addr(n)`; `nothing == nil`; `let cp: ptr int = unsafeAddr(c)` |
| `raw_memory.nim` | Manual heap: alloc/alloc0/create, realloc/resize, dealloc, sizeof | `cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * count))`; `realloc(buf, ...)`; `dealloc(buf)`; `var arr = create(int, 3)`; `resize(cast[ptr int](arr), 5)` |
| `ownership.nim` | Who frees: GC/ARC auto-free vs manual dealloc, `=destroy` on scope exit | `let b = a` (alias shares object); `var p2 = p1` (value copy); `dealloc(buf)`; `proc \`=destroy\`(l: var Logger)` |
| `casting.nim` | `T(x)` safe conversion vs `cast[T](x)` bit reinterpretation: chars, enums, pointers | `int(score)`, `uint8(200)`, `char(65)`, `Color(1)`, `green.int`, `ord(red)`; `cast[uint8](signed)`, `cast[pointer](addr(px))` |

## Common Patterns

```nim
type Box = ref object
  value: int
var b = Box(value: 7)
echo b.value        # `.` derefs a ref implicitly
echo b[]            # explicit deref with `[]`

var n = 10
let p: ptr int = addr(n)   # raw pointer to a mutable variable
p[] = 99                    # write through the pointer

let count = 5
var buf = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * count))
buf[0] = 1
dealloc(buf)                # you own raw memory — free it

type Logger = object
  path: string
proc `=destroy`(l: var Logger) =
  echo "closing ", l.path   # runs automatically at scope exit
```

## Test it

Run `test_it.nim` — it builds a `ref object` counter, allocates raw memory
for a buffer with `alloc0` and frees it with `dealloc`, then converts a
`char`/`int` with `ord()`. The three concepts combine: a traced `ref`, an
untraced `ptr` buffer, and an ordinal cast. Watch the ownership law —
the ref frees itself, the buf needs your `dealloc`.
