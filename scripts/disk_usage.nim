# Disk usage — walk a directory and show human-readable sizes
#   nim c -r scripts/disk_usage.nim [directory]
#
# Example:
#   nim c -r scripts/disk_usage.nim ~/projects

import std/[os, strutils, math]

proc humanSize(bytes: int64): string =
  const units = ["B", "KB", "MB", "GB", "TB"]
  var b = bytes.float64
  var unitIdx = 0
  while b > 1024.0 and unitIdx < units.high:
    b /= 1024.0
    inc unitIdx
  result = formatFloat(round(b, 1), ffDecimal, 1) & " " & units[unitIdx]

let root = if paramCount() >= 1: paramStr(1) else: "."

if not dirExists(root):
  echo "Error: directory not found: ", root
  quit(1)

var totalSize: int64 = 0
var fileCount = 0
var largestName = ""
var largestSize: int64 = 0

echo "── ", root, " ──"

for path in walkDirRec(root):
  try:
    let size = getFileSize(path)
    totalSize += size
    inc fileCount
    if size > largestSize:
      largestSize = size
      largestName = path
  except OSError:
    discard  # skip dirs and unreadable files

  if fileCount mod 5000 == 0:
    echo "  Scanned ", fileCount, " files... (", humanSize(totalSize), ")"

echo ""
echo "Results for: ", root
echo "  Files:  ", fileCount
echo "  Total:  ", humanSize(totalSize)
if largestSize > 0:
  echo "  Largest: ", largestName, " (", humanSize(largestSize), ")"
