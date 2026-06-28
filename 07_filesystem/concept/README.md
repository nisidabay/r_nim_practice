# 07 Filesystem — Files, Directories, Processes, and Debugging

## Quick Start

```bash
nim c -r 07_filesystem/concept/files.nim
nim c -r 07_filesystem/concept/pipes.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `files.nim` | File I/O, directory traversal, environment, shell | `readFile`/`writeFile`, `walkDir`/`walkDirRec`, `getEnv`, `execShellCmd` |
| `pipes.nim` | Process pipes: spawn programs and pipe data | `startProcess`, stdin/stdout streams, `execCmdEx`, exit codes |

## Common Patterns

```nim
writeFile("/tmp/test.txt", "data")
let content = readFile("/tmp/test.txt")
for line in lines("/tmp/test.txt"): echo line

for kind, path in walkDir("."):
  echo kind, " ", path

echo getEnv("PATH")

# Process pipes
import std/osproc
let p = startProcess("sort", args = ["-r"])
p.inputStream.writeLine("banana\napple\ncherry")
p.inputStream.close()
echo p.outputStream.readAll()
```

## Test it

Run `test_it.nim` — it uses `walkDirRec` to print files indented by
depth. It adds a file counter, filters by extension, and measures total
size. Play with the paths.
