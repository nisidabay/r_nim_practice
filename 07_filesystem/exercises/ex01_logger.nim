# Exercise 1: File Logger
import std/os

let logFile = "/tmp/nim_ex_log.txt"
writeFile(logFile, "=== Log started ===\n")
let exists = fileExists(logFile)
echo "File exists: ", exists
for line in lines(logFile):
  echo "LINE: ", line
removeFile(logFile)
echo "Cleaned up: ", not fileExists(logFile)
