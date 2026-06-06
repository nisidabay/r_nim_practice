# nim c -r filesize.nim <directory | file>
# Show disk usage like `du -sh` for a given path.
import std/[os, strutils, strformat]

proc formatSize(bytes: int64): string =
  const units = ["B", "KB", "MB", "GB"]
  var size = float(bytes)
  var unitIdx = 0
  while size >= 1024 and unitIdx < units.high:
    size = size / 1024
    inc unitIdx
  fmt"{size:.1f} {units[unitIdx]}"

proc dirSize(path: string): int64 =
  for kind, subpath in walkDir(path):
    case kind
    of pcFile: result += getFileSize(subpath)
    of pcDir: result += dirSize(subpath)
    else: discard

if paramCount() < 1:
  echo "Usage: filesize <path>"
  quit(1)

let target = paramStr(1)
if not existsOrCreateDir(target) and not fileExists(target):
  echo "Path not found: ", target
  quit(1)

var size: int64
if fileExists(target):
  size = getFileSize(target)
else:
  size = dirSize(target)

echo target, "  ", formatSize(size)
