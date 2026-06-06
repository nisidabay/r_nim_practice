# nim_journal.nim — FIXED fmt string issue
import std/strutils
import std/strformat
import std/times
import std/terminal
import std/os
import std/osproc
import std/json
import std/sequtils

const
  JournalBaseDir = "bin"
  JournalDir = joinPath(getHomeDir(), JournalBaseDir, "nim_journal")
  JournalFile = joinPath(JournalDir, "journal.json")

type
  JournalEntry = object
    id: int
    timestamp: string
    topic: string
    body: string

proc ensureJournalSetup() =
  if not dirExists(JournalDir): createDir(JournalDir)
  if not fileExists(JournalFile): writeFile(JournalFile, "[]")

proc loadEntries(): seq[JournalEntry] =
  ensureJournalSetup()
  let raw = readFile(JournalFile)
  if raw.strip() in ["", "[]"]: return @[]
  try:
    let node = parseJson(raw)
    for i in 0..<node.len:
      let e = node[i]
      result.add JournalEntry(
        id: e{"id"}.getInt(i),
        timestamp: e{"timestamp"}.getStr("unknown"),
        topic: e{"topic"}.getStr(""),
        body: e{"body"}.getStr("")
      )
  except: return @[]

proc saveEntries(es: seq[JournalEntry]) =
  ensureJournalSetup()
  var arr = newJArray()
  for e in es:
    arr.add(%*{
      "id": e.id,
      "timestamp": e.timestamp,
      "topic": e.topic,
      "body": e.body
    })
  let tmp = JournalFile & ".tmp"
  try:
    writeFile(tmp, $arr)
    removeFile(JournalFile)
    moveFile(tmp, JournalFile)
  except: raise

proc nextId(es: seq[JournalEntry]): int =
  if es.len == 0: 1 else: es.mapIt(it.id).max() + 1

proc longestLineLength(t: string): int =
  for line in t.splitLines():
    result = max(result, line.len)

proc printPanel(t: string, title = "", color = fgYellow, borderColor = fgBlue) =
  let maxLine = longestLineLength(t)
  let titleWidth = if title.len > 0: title.len + 2 else: 0
  let innerWidth = max(maxLine + 2, titleWidth + 2)
  let lines = t.splitLines()

  stdout.setForegroundColor(borderColor, true)
  stdout.write("╭")
  if title.len > 0:
    stdout.write(" ", title, " ")
    stdout.write(repeat("─", innerWidth - titleWidth))
  else:
    stdout.write(repeat("─", innerWidth))
  stdout.write("╮\n")
  stdout.resetAttributes()

  for line in lines:
    stdout.setForegroundColor(borderColor, true)
    stdout.write("│")
    stdout.setForegroundColor(color, true)
    stdout.write(" ", line)
    let pad = innerWidth - line.len - 1
    if pad > 0: stdout.write(repeat(" ", pad))
    stdout.resetAttributes()
    stdout.setForegroundColor(borderColor, true)
    stdout.write("│\n")
    stdout.resetAttributes()

  stdout.setForegroundColor(borderColor, true)
  stdout.write("╰", repeat("─", innerWidth), "╯\n")
  stdout.resetAttributes()

proc printError(msg: string) = printPanel(msg, "Error", fgRed, fgRed)
proc printSuccess(msg: string) = printPanel(msg, "Success", fgGreen, fgBlue)

proc runFzf(opts: seq[string], prompt: string): string =
  if opts.len == 0: return ""
  let now = getTime().toUnix()
  let tin = getTempDir() / fmt"fzf_in_{now}.txt"
  let tout = getTempDir() / fmt"fzf_out_{now}.txt"
  try:
    writeFile(tin, opts.join("\n"))
    let cmd = fmt"fzf --prompt {quoteShell(prompt)} --height 40% --layout reverse < {quoteShell(tin)} > {quoteShell(tout)}"
    discard execCmd(cmd)
    if fileExists(tout): return readFile(tout).strip()
  finally:
    for p in [tin, tout]:
      if fileExists(p): discard tryRemoveFile(p)

proc truncateLine(s: string, maxLen = 30): string =
  let t = s.strip()
  if t.len == 0: return "(empty)"
  if t.len > maxLen: t[0 .. maxLen-1] & "…" else: t

proc formatOption(i: int, e: JournalEntry): string =
  let lines = e.body.splitLines()
  let nonEmpty = lines.filterIt(it.strip() != "")
  let preview = if nonEmpty.len > 0: truncateLine(nonEmpty[0]) else: "(empty)"
  fmt"{i:03} | {e.id:03} | {e.topic} | {preview}"

# ✅ FIXED: Use string concatenation instead of nested fmt
proc addEntry() =
  stdout.write("Topic: ")
  let topic = stdin.readLine().strip()
  if topic.len == 0: printError("Topic required"); return

  stdout.write("Use EDITOR? (y/N): ")
  let edit = stdin.readLine().strip().toLowerAscii() == "y"
  var body: string

  if edit:
    let tmp = getTempDir() / fmt"jtmp_{getTime().toUnix()}.txt"
    defer: discard tryRemoveFile(tmp)
    writeFile(tmp, "# Journal\n")
    let editor = getEnv("EDITOR", "nvim")
    let cmd = editor & " " & quoteShell(tmp)
    if execCmd(cmd) != 0:
      printError("Editor failed"); return
    body = readFile(tmp).splitLines()
      .filterIt(not it.strip().startsWith('#'))
      .join("\n")
      .strip()
  else:
    echo "Body (Ctrl+D):"
    body = stdin.readAll().strip()

  if body.len == 0: printError("Empty body"); return

  let dt = now()
  let ts = fmt"{dt.year}-{ord(dt.month)+1:02}-{dt.monthday:02} {dt.hour:02}:{dt.minute:02}:{dt.second:02}"
  var entries = loadEntries()
  let newId = entries.nextId()
  entries.add JournalEntry(id: newId, timestamp: ts, topic: topic, body: body)
  saveEntries(entries)
  printSuccess(fmt"Saved entry #{newId}")

proc listEntries() =
  let es = loadEntries()
  if es.len == 0: printError("No entries"); return

  var opts: seq[string]
  for i, e in es:
    opts.add(formatOption(i, e))

  let sel = runFzf(opts, "Entries")
  if sel.len == 0: return

  try:
    let i = parseInt(sel.split(" | ")[0])
    if i in 0..<es.len:
      let e = es[i]
      let display = fmt"ID: {e.id} - {e.timestamp} - Topic: {e.topic} - {e.body}"
      printPanel(display, fmt"Entry {i}")
  except: printError("Invalid")

proc searchEntries(q: string) =
  let query = if q.len > 0: q else: (stdout.write("Search: "); stdin.readLine().strip())
  if query.len == 0: return

  let es = loadEntries()
  let lo = query.toLowerAscii()

  var matches: seq[(int, JournalEntry)]
  for i, e in es:
    if e.topic.toLowerAscii().contains(lo) or e.body.toLowerAscii().contains(lo):
      matches.add((i, e))

  if matches.len == 0:
    printError(fmt"No matches for '{query}'")
    return

  var opts: seq[string]
  for (i, e) in matches:
    opts.add(formatOption(i, e))

  let sel = runFzf(opts, fmt"Search: {query}")
  if sel.len == 0: return

  try:
    let i = parseInt(sel.split(" | ")[0])
    if i in 0..<es.len:
      let e = es[i]
      let display = fmt"ID: {e.id} - {e.timestamp} - Topic: {e.topic} - {e.body}"
      printPanel(display, fmt"Match {i}")
  except: printError("Invalid")

proc deleteEntry() =
  let es = loadEntries()
  if es.len == 0: printError("No entries"); return

  var opts: seq[string]
  for i, e in es:
    opts.add(formatOption(i, e))

  let sel = runFzf(opts, "🗑️ Delete")
  if sel.len == 0: return

  try:
    let i = parseInt(sel.split(" | ")[0])
    if i notin 0..<es.len: printError("Invalid"); return
    let e = es[i]
    stdout.write(fmt"Delete #{e.id} '{e.topic}'? (y/N): ")
    if stdin.readLine().strip().toLowerAscii() != "y": return
    var newEs = es
    newEs.delete(i)
    saveEntries(newEs)
    printSuccess(fmt"Deleted #{e.id}")
  except: printError("Invalid")

proc showHelp() =
  echo """
  Activity journal

  (Default)   → add
  -a          → add
  -l          → list
  -s TERM     → search
  -d          → delete
  -h          → help
"""

proc main() =
  let args = commandLineParams()
  if args.len == 0 or args[0] == "-a": addEntry()
  elif args[0] == "-l": listEntries()
  elif args[0] == "-s": searchEntries(if args.len > 1: args[1] else: "")
  elif args[0] == "-d": deleteEntry()
  elif args[0] in ["-h", "--help"]: showHelp()
  else: printError(fmt"Unknown: {args[0]}"); showHelp()

when isMainModule: main()
