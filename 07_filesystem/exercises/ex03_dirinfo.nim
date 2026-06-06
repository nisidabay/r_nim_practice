# Exercise 3: Directory Info
import std/os

let dir = "/tmp"
var files, dirs: int
for kind, path in walkDir(dir):
  case kind
  of pcFile: inc files
  of pcDir: inc dirs
  else: discard
echo "Files: ", files, ", Dirs: ", dirs
