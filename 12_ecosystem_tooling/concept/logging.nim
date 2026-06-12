# std/logging — structured logging with levels and handlers
#   nim c -r logging.nim

import std/logging

# ── Setup: create a console logger ──────────────────────────────────────

var consoleLogger = newConsoleLogger(fmtStr = "$levelid: $msg")
addHandler(consoleLogger)

# ── Log levels ──────────────────────────────────────────────────────────

log(lvlDebug, "This is a debug message — verbose detail")
log(lvlInfo, "This is an info message — normal operation")
log(lvlWarn, "This is a warning — something unusual")
log(lvlError, "This is an error — something failed")
log(lvlFatal, "This is a fatal message — critical failure")

# ── Convenience procs ───────────────────────────────────────────────────

debug("Shortcut for log(lvlDebug, ...)")
info("Shortcut for log(lvlInfo, ...)")
warn("Shortcut for log(lvlWarn, ...)")
error("Shortcut for log(lvlError, ...)")
fatal("Shortcut for log(lvlFatal, ...)")

# ── Format strings ─────────────────────────────────────────────────────

# The fmtStr supports these placeholders:
#   $date        — current date
#   $time        — current time
#   $levelid     — short level (DEBUG, INFO, WARN, ERROR, FATAL)
#   $levelname   — full level name

var detailedLogger = newConsoleLogger(fmtStr = "$date $time $levelid — $msg")
addHandler(detailedLogger)

info("Now using a detailed format with timestamps")

# ── Filtering ──────────────────────────────────────────────────────────

# Set threshold level — messages below this are suppressed
setLogFilter(lvlWarn)
debug("This will NOT appear — below threshold")  # suppressed
warn("This WILL appear — at threshold level")
error("This WILL appear — above threshold")

# Reset filter to show everything
setLogFilter(lvlDebug)
info("Filter reset — all messages visible again")