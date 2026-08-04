# nim c -r tuples.nim
# Enums are now covered in enums.nim

# Tuples: positional, unnamed or named
var point = (10, 20)
echo point[0], ", ", point[1]     # 10, 20

var named = (x: 5, y: 12)
echo named.x, ", ", named.y       # 5, 12

# Unpacking
let (a, b) = point
echo a, ", ", b

# ── Thinking in Nim ────────────────────────────
# Tuples are first-class and lightweight: `(x: 5, y: 12)` needs no type
# declaration, and destructuring with `let (a, b) = point` reads like the
# natural thing to do. They're the go-to for returning multiple values
# without reaching for a full object type.
