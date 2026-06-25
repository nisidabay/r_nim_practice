# 07 Filesystem — Test It
# Walk a directory tree with indentation, file count, and total size.

import std/[os, strformat, strutils]

proc exploreDirectory(root: string, extFilter: string = "") =
  var fileCount = 0
  var totalSize: int64 = 0

  for path in walkDirRec(root):
    if extFilter.len > 0 and path.splitFile().ext != extFilter:
      continue

    let depth = count(path, '/') - count(root, '/')
    let indent = "  ".repeat(depth)
    let size = getFileSize(path)
    echo fmt"{indent}{path.extractFilename()} ({size} bytes)"

    fileCount += 1
    totalSize += size

  echo "\nFiles: ", fileCount
  echo "Total size: ", totalSize, " bytes"

exploreDirectory(".")

# Try filtering by extension: exploreDirectory(".", ".nim")
# Try with a different root directory.
# Try adding the last modified time.
