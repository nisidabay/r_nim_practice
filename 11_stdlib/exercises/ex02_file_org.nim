# ex02_file_org.nim — Scan dir, sort filenames, organize by extension
#   nim c -r exercises/ex02_file_org.nim
#
# Scans a directory, sorts filenames with std/algorithm, moves files
# into subdirectories by extension.

import std/[os, algorithm]

proc organizeDir(dir: string) =
  ## Scan `dir`, sort entries, move each file into `ext/` subfolder.
  if not dirExists(dir):
    echo "Directory does not exist: ", dir
    return

  # Collect regular files only
  var files: seq[string] = @[]
  for kind, path in walkDir(dir):
    if kind == pcFile:
      files.add(path)

  # Sort alphabetically
  files.sort()

  echo "Found ", files.len, " files in ", dir

  for f in files:
    let (_, name, ext) = splitFile(f)
    if ext.len == 0:
      continue                     # skip files with no extension

    let subdir = dir / ext[1..^1]  # remove leading dot
    createDir(subdir)
    let dest = subdir / name & ext
    try:
      moveFile(f, dest)
      echo "  Moved ", name & ext, " → ", ext[1..^1], "/"
    except:
      echo "  Skipped ", name & ext, " (already in target?)"

# ── Demo ────────────────────────────────────────────────────────────────────

let demoDir = getHomeDir() / ".nim_fileorg_demo"
createDir(demoDir)

# Create sample files of various types
writeFile(demoDir / "notes.txt", "sample text")
writeFile(demoDir / "data.txt", "more text")
writeFile(demoDir / "script.nim", "echo hi")
writeFile(demoDir / "lib.nim", "proc foo*() = echo hi")
writeFile(demoDir / "readme.md", "# Readme")

echo "Before:"
for k, p in walkDir(demoDir):
  echo "  ", p

organizeDir(demoDir)

echo "\nAfter:"
for k, p in walkDir(demoDir):
  echo "  ", p

# Cleanup
removeDir(demoDir)
echo "\nCleanup complete."