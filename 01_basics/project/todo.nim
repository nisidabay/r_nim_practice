# nim c -r todo.nim < add | list | done | remove >
# A simple todo.txt manager — add, list, mark done, remove.
import std/[os, strutils]

let todoFile = getHomeDir() / ".nim_todo.txt"
let args = commandLineParams()

if args.len < 1:
  echo "Usage: todo <add|list|done|remove> [args]"
  quit(1)

case args[0]
of "add":
  if args.len < 2:
    echo "Usage: todo add \"your task here\""
    quit(1)
  let task = args[1..^1].join(" ")
  try:
    writeFile(todoFile, readFile(todoFile) & task & "\n")
    echo "✓ Added: ", task
  except IOError:
    writeFile(todoFile, task & "\n")
    echo "✓ Added: ", task

of "list":
  if not fileExists(todoFile):
    echo "(empty)"
    quit(0)
  var i = 1
  for line in lines(todoFile):
    echo i, ". ", line
    inc i

of "done":
  if args.len < 2:
    echo "Usage: todo done <number>"
    quit(1)
  let n = parseInt(args[1])
  var lines = readLines(todoFile)
  if n < 1 or n > lines.len:
    echo "Invalid task number"
    quit(1)
  echo "✓ Completed: ", lines[n-1]
  lines.delete(n-1)
  writeFile(todoFile, lines.join("\n") & "\n")

of "remove":
  if args.len < 2:
    echo "Usage: todo remove <number>"
    quit(1)
  let n = parseInt(args[1])
  var lines = readLines(todoFile)
  if n < 1 or n > lines.len:
    echo "Invalid task number"
    quit(1)
  echo "✗ Removed: ", lines[n-1]
  lines.delete(n-1)
  writeFile(todoFile, lines.join("\n") & "\n")

else:
  echo "Unknown command: ", args[0]
  echo "Commands: add, list, done, remove"
