# nim c -r tree.nim <directory>
# Walk a directory recursively and print an indented tree.
import std/[algorithm, os, strutils]
# sort + cmp from std/algorithm — covered in module 11

if paramCount() < 1:
  echo "Usage: tree <directory>"
  echo "  e.g. tree /some/path"
  quit(1)

let root = paramStr(1)
if not dirExists(root):
  echo "Directory not found: ", root
  quit(1)

proc printTree(dir: string; indent: int) =
  var entries: seq[(PathComponent, string)] = @[]
  for kind, path in walkDir(dir):
    entries.add((kind, path))
  # Sort: directories first, then files
  entries.sort do (a, b: (PathComponent, string)) -> int:
    if a[0] == b[0]:
      result = cmp(a[1], b[1])
    elif a[0] == pcDir:
      result = -1
    else:
      result = 1

  for i, (kind, path) in entries.pairs:
    let name = path.splitPath().tail
    let isLast = i == entries.high
    let prefix = if isLast: "└── " else: "├── "
    echo repeat("    ", indent), prefix, name
    if kind == pcDir:
      printTree(path, indent + 1)

echo root
printTree(root, 0)