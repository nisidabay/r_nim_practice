# nim c -r filecheck.nim manifest.txt
# File integrity checker: verify files match expected MD5 hashes.
#
# manifest.txt format (one per line):
#   <md5hash>  <filename>
#
# Reports OK / MISMATCH / MISSING for each file.
# Exits 0 if all files pass, non-zero otherwise.

import std/os
import std/sha1
import std/strutils

# ── Pure procs (testable) ─────────────────────────────────────────────

proc parseManifest*(lines: seq[string]): seq[tuple[hash: string, path: string]] =
  ## Parse manifest lines like "abc123  myfile.txt" into tuples.
  for line in lines:
    let trimmed = line.strip()
    if trimmed.len == 0 or trimmed.startsWith("#"):
      continue
    let parts = trimmed.splitWhitespace(maxsplit = 1)
    if parts.len == 2:
      result.add((hash: parts[0], path: parts[1].strip()))

proc hashMatch*(filename, expectedHash: string): bool =
  ## Return true if file's MD5 matches expected hash.
  if not fileExists(filename):
    return false
  let content = readFile(filename)
  let actual = $secureHash(content)
  result = cmpIgnoreCase(actual, expectedHash) == 0

# ── Main orchestrator ─────────────────────────────────────────────────

proc main() =
  if paramCount() < 1:
    echo "Usage: filecheck <manifest.txt>"
    echo "Manifest format: md5hash  filename  (one per line)"
    quit(1)

  let manifestPath = paramStr(1)
  if not fileExists(manifestPath):
    echo "Manifest not found: ", manifestPath
    quit(1)

  let lines = readFile(manifestPath).splitLines()
  let entries = parseManifest(lines)

  if entries.len == 0:
    echo "No entries found in manifest."
    quit(0)

  var allPassed = true
  for entry in entries:
    if not fileExists(entry.path):
      echo "[MISSING] ", entry.path
      allPassed = false
    elif hashMatch(entry.path, entry.hash):
      echo "[OK]      ", entry.path
    else:
      echo "[MISMATCH] ", entry.path
      allPassed = false

  if allPassed:
    echo "\nAll ", entries.len, " files OK."
    quit(0)
  else:
    echo "\nSome files failed."
    quit(1)

when isMainModule:
  main()
