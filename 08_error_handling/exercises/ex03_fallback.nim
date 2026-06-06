# Exercise 3: File Reader with Fallback
import std/os

proc readOrDefault(path: string, default: string): string =
  try: result = readFile(path)
  except IOError: result = default

echo readOrDefault("/etc/hostname", "localhost")
echo readOrDefault("/nonexistent", "Fallback!")
