# std/terminal — ANSI colors, cursor control, terminal dimensions
#   nim c -r terminal.nim

import std/terminal

# ── Colors ──────────────────────────────────────────────────────────────

setForegroundColor(fgRed)
echo "Red text"
resetAttributes()

setForegroundColor(fgGreen)
echo "Green text"
resetAttributes()

setForegroundColor(fgYellow)
echo "Yellow text"
resetAttributes()

# Background colors
setBackgroundColor(bgBlue)
setForegroundColor(fgWhite)
echo "White on blue"
resetAttributes()

# Combined — bright variants
setForegroundColor(fgCyan)
echo "Cyan text — standard"
resetAttributes()

# Style flags
setForegroundColor(fgYellow)
setStyle({styleBright})
echo "Bright yellow"
resetAttributes()

# ── Cursor control ──────────────────────────────────────────────────────

echo "Line 1"
echo "Line 2"
cursorUp(1)
echo "← overwrote Line 2"

# Move to a specific position
setCursorPos(10, 5)
echo "At col 10, row 5"

# ── Terminal dimensions ─────────────────────────────────────────────────

let w = terminalWidth()
let h = terminalHeight()
echo "Terminal is ", w, " columns x ", h, " rows"

# ── Reset everything ────────────────────────────────────────────────────

resetAttributes()
echo "Back to normal"