# csvreader.nim — CsvParser wrapper returning seq[LogEntry] ref objects
#   Demonstrates: parsecsv parsing, OOP with LogEntry hierarchy

import std/parsecsv
import std/strutils

type
  LogEntry* = ref object of RootObj
    timestamp*: string
    level*: string
    source*: string
    message*: string

  ErrorEntry* = ref object of LogEntry
  WarnEntry*  = ref object of LogEntry
  InfoEntry*  = ref object of LogEntry
  DebugEntry* = ref object of LogEntry

proc newLogEntry(kind: string; timestamp, level, source, message: string): LogEntry =
  ## Factory — returns the correct subtype based on level string
  case level.toUpperAscii()
  of "ERROR", "FATAL":
    ErrorEntry(timestamp: timestamp, level: level, source: source, message: message)
  of "WARN":
    WarnEntry(timestamp: timestamp, level: level, source: source, message: message)
  of "INFO":
    InfoEntry(timestamp: timestamp, level: level, source: source, message: message)
  else:
    DebugEntry(timestamp: timestamp, level: level, source: source, message: message)

proc readLogCsv*(path: string): seq[LogEntry] =
  ## Parse a CSV log file and return typed LogEntry objects
  var parser: CsvParser
  parser.open(path, separator = ',', quote = '"')

  # Expect headers: timestamp,level,source,message
  parser.readHeaderRow()

  while parser.readRow():
    let entry = newLogEntry(
      kind = parser.rowEntry("level"),
      timestamp = parser.rowEntry("timestamp"),
      level = parser.rowEntry("level"),
      source = parser.rowEntry("source"),
      message = parser.rowEntry("message"),
    )
    result.add(entry)

  parser.close()