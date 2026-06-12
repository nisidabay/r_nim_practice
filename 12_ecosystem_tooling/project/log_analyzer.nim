# log_analyzer.nim — main entry: CLI tool for parsing and displaying CSV logs
#   nim c -r log_analyzer.nim [--config config.ini] [--input log.csv]
#
# Demonstrates: parsecfg, parsecsv, terminal, logging, OOP, pragmas

import std/os
import std/logging
import std/strformat
import std/strutils

import config, csvreader, display

# ── Logging setup ───────────────────────────────────────────────────────

var logger = newConsoleLogger(fmtStr = "$levelid: $msg")
addHandler(logger)

# ── Pragmas demo ────────────────────────────────────────────────────────

{.push inline.}

proc isSevere*(entry: LogEntry): bool {.inline.} =
  ## Hot-path check — inlined for performance
  entry.level.toUpperAscii() in ["ERROR", "FATAL"]

{.pop.}

# Register handlers (demonstrating {.used.} pragma)
proc onErrorHandler() {.used.} =
  warn("Error handler registered — not called directly")

proc onShutdown() {.used.} =
  info("Shutdown handler registered — for demonstration")

# ── CLI argument parsing ────────────────────────────────────────────────

proc parseArgs(): tuple[configPath: string, csvPath: string] =
  ## Simple arg parser: --config path --input path
  result.configPath = "config.ini"
  result.csvPath = "log.csv"

  var i = 1
  while i < paramCount():
    let key = paramStr(i)
    let val = paramStr(i + 1)
    case key
    of "--config", "-c":
      result.configPath = val
    of "--input", "-i":
      result.csvPath = val
    else:
      discard
    i += 2

# ── Main ────────────────────────────────────────────────────────────────

proc main() =
  info("Log Analyzer starting")

  let (configPath, csvPath) = parseArgs()
  info(&"Config: {configPath}")
  info(&"Input:  {csvPath}")

  # Load config
  if not fileExists(configPath):
    fatal(&"Config file not found: {configPath}")
    quit(1)

  let appConfig = loadAppConfig(configPath)
  info("Config loaded: verbosity = " & appConfig.display.verbosity)

  # Parse CSV
  if not fileExists(csvPath):
    fatal(&"CSV file not found: {csvPath}")
    quit(1)

  let entries = readLogCsv(csvPath)
  info(&"Parsed {entries.len} log entries")

  # Separate severe entries (using the inline proc)
  var severeCount = 0
  for entry in entries:
    if entry.isSevere():
      severeCount += 1
  if severeCount > 0:
    warn(&"Found {severeCount} severe entries")

  # Render
  renderHeader(appConfig)
  renderEntries(entries)
  renderFooter(entries)

  info("Log Analyzer finished")

when isMainModule:
  main()