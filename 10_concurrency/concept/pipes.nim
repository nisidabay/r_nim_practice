# Process pipes — spawn external programs and talk to them
#
# The problem: you want to pipe data through an external program, like
# bash does with `echo "list" | fzf`. But you want this inside Nim, not
# shelling out. You want to send input, read output, control the process.
#
# Nim's `startProcess` gives you stdin/stdout/stderr streams for any
# subprocess. You write to its stdin, read from its stdout — as objects,
# not raw file descriptors.

import std/[osproc, streams, strutils]

# ── Real example: pipe through `sort` ─────────────────────────────────

proc pipeThroughSort(data: seq[string]): string =
  # Start the `sort` process. poEvalCommand means "treat as shell command"
  var process = startProcess(
    "sort",
    args = ["-r"],                    # -r = reverse sort
    options = {poUsePath}              # look up 'sort' in $PATH
  )

  # Write data to sort's stdin
  for line in data:
    process.inputStream.writeLine(line)
  process.inputStream.close()          # Close stdin → sort knows input is done

  # Read sorted output from sort's stdout
  result = process.outputStream.readAll().strip()
  process.close()

let fruits = @["banana", "apple", "cherry", "date"]
echo pipeThroughSort(fruits)
# Output: date, cherry, banana, apple (reverse alphabetical)


# ── Real example: pipe through `grep` ─────────────────────────────────

proc searchLogs(pattern: string, logContent: string): seq[string] =
  var process = startProcess(
    "grep",
    args = ["-n", pattern],            # -n = show line numbers
    options = {poUsePath}
  )

  process.inputStream.write(logContent)
  process.inputStream.close()

  result = @[]
  for line in process.outputStream.lines():
    result.add(line)
  process.close()

let logs = """
INFO: Server started
ERROR: Connection refused on port 8080
INFO: User carlos logged in
ERROR: Timeout after 30s
INFO: Shutting down
"""

let errors = searchLogs("ERROR", logs)
echo "Errors found:\n", errors.join("\n")
# Output:
#   2:ERROR: Connection refused on port 8080
#   4:ERROR: Timeout after 30s


# ── Error handling: check exit codes ──────────────────────────────────

proc safeExec(cmd: string, args: varargs[string]): string =
  var process = startProcess(
    cmd,
    args = @args,
    options = {poUsePath, poStdErrToStdOut}  # merge stderr into stdout
  )
  result = process.outputStream.readAll()
  let exitCode = process.waitForExit()
  process.close()

  if exitCode != 0:
    echo "WARNING: '", cmd, "' exited with code ", exitCode
    echo "Output: ", result

# This is how app_launcher.nim runs FZF — it spawns an interactive process
# and reads the selection. Nim makes stdin/stdout streams first-class objects.
# No subprocess.PIPE, no manual fd handling, no shell escaping issues.
