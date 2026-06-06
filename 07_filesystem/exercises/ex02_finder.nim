# Exercise 2: File Finder
import std/os, std/strutils

let startDir = "/tmp"
echo "Files in ", startDir, ":"
for path in walkDirRec(startDir):
  if path.endsWith(".log"):
    echo "  ", path
