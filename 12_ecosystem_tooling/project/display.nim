# display.nim — Terminal rendering for LogEntry objects
#   Colorizes output by entry type using std/terminal

import std/terminal
import std/strformat
import std/strutils

import csvreader
import config

# ── Method dispatch for formatting ──────────────────────────────────────

method format*(entry: LogEntry): string {.base.} =
  ## Base format — no color
  &"{entry.timestamp} [{entry.level}] {entry.source}: {entry.message}"

method format*(entry: ErrorEntry): string =
  ## Red for errors and fatals
  setForegroundColor(fgRed)
  result = &"{entry.timestamp} [ERROR] {entry.source}: {entry.message}"
  resetAttributes()

method format*(entry: WarnEntry): string =
  ## Yellow for warnings
  setForegroundColor(fgYellow)
  result = &"{entry.timestamp} [WARN]  {entry.source}: {entry.message}"
  resetAttributes()

method format*(entry: InfoEntry): string =
  ## Green for info
  setForegroundColor(fgGreen)
  result = &"{entry.timestamp} [INFO]  {entry.source}: {entry.message}"
  resetAttributes()

method format*(entry: DebugEntry): string =
  ## Dim/cyan for debug
  setForegroundColor(fgCyan)
  result = &"{entry.timestamp} [DEBUG] {entry.source}: {entry.message}"
  resetAttributes()

# ── Rendering ───────────────────────────────────────────────────────────

proc renderHeader*(config: AppConfig) =
  ## Display header with theme colors
  setForegroundColor(config.display.fgColor)
  setBackgroundColor(config.display.bgColor)
  echo "═══ Log Analyzer ═══"
  resetAttributes()
  echo &"Verbosity: {config.display.verbosity}"
  echo ""

proc renderEntries*(entries: seq[LogEntry]) =
  ## Render all entries with type-specific coloring
  for entry in entries:
    echo entry.format()

proc renderFooter*(entries: seq[LogEntry]) =
  ## Render summary footer with per-level counts
  var counts: array[4, int]  # error, warn, info, debug

  for entry in entries:
    case entry.level.toUpperAscii()
    of "ERROR", "FATAL":
      counts[0] += 1
    of "WARN":
      counts[1] += 1
    of "INFO":
      counts[2] += 1
    else:
      counts[3] += 1

  echo ""
  echo "─── Summary ───"
  setForegroundColor(fgRed)
  echo &"  Errors:   {counts[0]}"
  resetAttributes()
  setForegroundColor(fgYellow)
  echo &"  Warnings: {counts[1]}"
  resetAttributes()
  setForegroundColor(fgGreen)
  echo &"  Info:     {counts[2]}"
  resetAttributes()
  setForegroundColor(fgCyan)
  echo &"  Debug:    {counts[3]}"
  resetAttributes()
  echo &"  Total:    {entries.len}"