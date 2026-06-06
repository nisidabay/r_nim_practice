# nim c -r enums_tuples.nim

type
  Color = enum
    red, green, blue

var c: Color = red
echo c                            # red

# Ordinal values
echo ord(red)                     # 0

# Tuples: positional, unnamed or named
var point = (10, 20)
echo point[0], ", ", point[1]     # 10, 20

var named = (x: 5, y: 12)
echo named.x, ", ", named.y       # 5, 12

# Unpacking
let (a, b) = point
echo a, ", ", b
