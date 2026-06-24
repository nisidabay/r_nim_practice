# Bulk rename files using regex
#   nim c -r scripts/bulk_rename.nim <pattern> <replacement> [directory]
#
# Example:
#   nim c -r scripts/bulk_rename.nim "\.png$" ".jpg" ~/Pictures
#   # Renames all .png → .jpg in ~/Pictures

import std/[os, strutils]

if paramCount() < 2:
  echo "Usage: bulk_rename <pattern> <replacement> [directory]"
  echo "  e.g. bulk_rename '.png$' '.jpg' ."
  quit(1)

let pattern = paramStr(1)
let replacement = paramStr(2)
let dir = if paramCount() >= 3: paramStr(3) else: "."

if not dirExists(dir):
  echo "Error: directory not found: ", dir
  quit(1)

var renamed = 0
for kind, path in walkDir(dir):
  if kind != pcFile: continue
  let name = extractFilename(path)
  let newName = name.replace(pattern, replacement)
  if newName != name:
    let newPath = dir / newName
    try:
      moveFile(path, newPath)
      echo "  ", name, " → ", newName
      inc renamed
    except OSError as e:
      echo "  Error renaming ", name, ": ", e.msg

echo "\nRenamed ", renamed, " file(s)"
