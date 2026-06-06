# nim c -r walk_files.nim
# walkDir, walkDirRec — iterate over directories.

import std/os

let testDir = "/tmp/nim_walk_demo"
createDir(testDir)
writeFile(testDir / "a.txt", "aa")
writeFile(testDir / "b.txt", "bb")
createDir(testDir / "sub")
writeFile(testDir / "sub" / "c.txt", "cc")

# walkDir: one level, returns (kind, path)
for kind, path in walkDir(testDir):
  echo kind, " ", path            # pcFile or pcDir

# walkDirRec: recursive
echo "\n--- recursive ---"
for path in walkDirRec(testDir):
  echo path

# Cleanup
removeDir(testDir)
