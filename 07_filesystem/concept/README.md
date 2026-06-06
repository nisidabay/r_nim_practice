# 07 Filesystem — Files, Directories, and System Calls

## Quick Start

```bash
nim c -r 07_filesystem/concept/files.nim
nim c -r 07_filesystem/concept/walk_files.nim
nim c -r --passL:"-lm" 07_filesystem/concept/ffi_calling.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `files.nim` | readFile, writeFile, readLines, fileExists, removeFile | Standard I/O — no streams boilerplate |
| `walk_files.nim` | walkDir, walkDirRec, createDir, removeDir | Recursive directory traversal |
| `ffi_calling.nim` | Calling C functions from Nim | Zero-overhead FFI — declare, link, call |
| `ffi_exporting.nim` | Exporting Nim code to C/Python | `--app:lib` builds a shared library |

## Common Patterns

```nim
writeFile("/tmp/test.txt", "data")
let content = readFile("/tmp/test.txt")
for line in lines("/tmp/test.txt"): echo line

for kind, path in walkDir("."):
  echo kind, " ", path
```

## Now Build Your Own

Write a `tree` clone: recursively walk a directory and print it as an
indented tree structure.
