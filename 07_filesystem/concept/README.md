# 07 Filesystem — Files, Directories, and System Calls

## Quick Start

```bash
nim c -r 07_filesystem/concept/files.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `files.nim` | File I/O, directory traversal, environment, shell | `readFile`/`writeFile`, `walkDir`/`walkDirRec`, `getEnv`, `execShellCmd` |

## Common Patterns

```nim
writeFile("/tmp/test.txt", "data")
let content = readFile("/tmp/test.txt")
for line in lines("/tmp/test.txt"): echo line

for kind, path in walkDir("."):
  echo kind, " ", path

echo getEnv("PATH")
```

## Test it

Run `test_it.nim` — it uses `walkDirRec` to print files indented by
depth. It adds a file counter, filters by extension, and measures total
size. Play with the paths.
