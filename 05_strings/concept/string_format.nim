# nim c -r string_format.nim
# Beyond strutils: format, alignment, number formatting.

import std/strutils

# Width and alignment with alignLeft/align/center
echo "Name".alignLeft(12) & "Score".align(6)
echo "Carlos".alignLeft(12) & "85".align(6)
echo "Ana".alignLeft(12) & "92".align(6)

# Float formatting with formatFloat
import std/strformat
let pi = 3.1415926535
echo fmt"{pi:.2f}"               # 3.14
echo fmt"{pi:.6f}"               # 3.141593

# formatBiggestFloat — shortest representation
echo formatBiggestFloat(1.0e6, ffDecimal)   # 1000000.0

# Multi-line strings
let html = """
<html>
  <body>Hello</body>
</html>
"""
echo html

# Unicode
let msg = "你好 Nim"
echo msg, " (length: ", msg.len, " chars)"
