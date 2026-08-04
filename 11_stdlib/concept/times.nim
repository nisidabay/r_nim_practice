# std/times — datetime, formatting, duration, Unix timestamps
#   nim c -r concept/times.nim

import std/times

# ── now() and format() ────────────────────────────────────────────────

let rightNow = now()
echo "Now:     ", rightNow.format("yyyy-MM-dd HH:mm:ss")

# ── parse() ───────────────────────────────────────────────────────────

let past = parse("2020-01-01", "yyyy-MM-dd")
echo "Past:    ", past

# ── Duration: initDuration, +, -, inDays ──────────────────────────────

let span = initDuration(days=7, hours=3)
let later = rightNow + span
echo "Late:    ", later.format("yyyy-MM-dd HH:mm:ss")

let diff = rightNow - past
echo "Since:   ", diff.inDays, " days"

# ── Comparison: ==, <, > ──────────────────────────────────────────────

echo "now > past?   ", rightNow > past    # true
echo "now == now?   ", rightNow == rightNow  # true

# ── Unix timestamps: toUnix / fromUnix ────────────────────────────────

let ts = rightNow.toTime.toUnix   # DateTime → Time → int64
echo "Unix:    ", ts
echo "Back:    ", fromUnix(ts).local.format("yyyy-MM-dd HH:mm:ss")

# ── Practical: file-age threshold ─────────────────────────────────────

let oneDayAgo = rightNow - initDuration(days=1)
echo "Yesterday: ", oneDayAgo.format("yyyy-MM-dd HH:mm:ss")

# ── Verification ──────────────────────────────────────────────────────

assert rightNow == rightNow
assert rightNow > past
assert rightNow < later
assert diff.inDays >= 2366  # 2020-01-01 to now is at least this many days

echo "All times assertions passed."

# ── Thinking in Nim ────────────────────────────
# std/times separates the DateTime (calendar wall-clock) from Time
# (Unix seconds) and Duration (elapsed spans). Format and parse with
# strftime-style patterns, add/subtract Durations, compare directly, and
# cross to Unix timestamps via toTime/toUnix when you need epoch seconds.
