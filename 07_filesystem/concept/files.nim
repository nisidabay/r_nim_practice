# nim c -r files.nim
# readFile, writeFile, readLines, walkDir, env vars — file I/O and OS.

import std/os

let filename = "/tmp/nim_demo.txt"

# Write
writeFile(filename, "line one\nline two\nline three\n")
echo "Wrote: ", filename

# Read entire file
let content = readFile(filename)
echo content

# Read line by line
for line in lines(filename):
  echo "> ", line

# readLines returns a seq
let all = readLines(filename)
echo "Number of lines: ", all.len

# Exists? Remove?
echo "Exists? ", fileExists(filename)
removeFile(filename)
echo "Now? ", fileExists(filename)


# ── Directory traversal ─────────────────────────────────────────────────

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


# ── Environment and shell ───────────────────────────────────────────────

echo "\nPATH: ", getEnv("PATH")
echo "HOME exists? ", existsEnv("HOME")
echo "Home dir: ", getHomeDir()
echo "App filename: ", getAppFilename()

# execShellCmd runs a shell command; returns exit code (0 = success)
let exitCode = execShellCmd("echo 'Hello from shell!'")
echo "Shell exit code: ", exitCode

echo "Sleeping for 10 ms..."
sleep(10)
echo "Done."

# ── Thinking in Nim ────────────────────────────
# Nim makes file I/O a stdlib import away — `readFile`, `walkDir` and
# `walkDirRec` come built-in, no third-party dependency. Path handling,
# env vars and even process calls all share one module (`std/os`), so the
# OS feels like part of the language rather than a separate API.
