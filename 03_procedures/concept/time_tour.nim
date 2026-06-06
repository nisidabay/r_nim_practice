# times — dates, times, durations, monotonic clock
#   import std/[times, monotimes]

import std/[times, monotimes]

# ── Getting current time ──────────────────────────────────────────────

let now = now()                    # DateTime — local time
echo "Now: ", now

let utcNow = utc(now())            # DateTime in UTC
echo "UTC: ", utcNow

echo "Unix epoch: ", fromUnix(0)


# ── Creating specific dates ───────────────────────────────────────────

let future = dateTime(2030, mJan, 15, 12, 0, 0)
echo "Future: ", future

let birthday = dateTime(2026, mMay, 6, 0, 0, 0)
echo "Date only: ", birthday


# ── Formatting ────────────────────────────────────────────────────────

echo now.format("yyyy-MM-dd")              # "2026-05-06"
echo now.format("dd/MM/yyyy HH:mm:ss")     # "06/05/2026 14:30:45"
echo now.format("MMMM d, yyyy")            # "May 6, 2026"


# ── Parsing from strings ──────────────────────────────────────────────

let parsed = parse("2026-05-06", "yyyy-MM-dd")
echo "Parsed: ", parsed

let withTime = parse("06/05/2026 14:30", "dd/MM/yyyy HH:mm")
echo "With time: ", withTime


# ── Date arithmetic ───────────────────────────────────────────────────

let tomorrow = now + 1.days
echo "Tomorrow: ", tomorrow.format("yyyy-MM-dd")

let nextWeek = now + 1.weeks
let threeHoursBack = now - 3.hours
let halfHour = initDuration(minutes = 30)


# ── Duration between dates ────────────────────────────────────────────

let startOfYear = dateTime(2026, mJan, 1, 0, 0, 0)
let diff = now - startOfYear
echo "Days since Jan 1: ", diff.inDays
echo "Hours since Jan 1: ", diff.inHours


# ── Date components ───────────────────────────────────────────────────

echo "Year: ", now.year
echo "Month: ", now.month          # mMay
echo "Day: ", now.monthday         # 6
echo "Weekday: ", now.weekday      # dWed
echo "Hour: ", now.hour
echo "Minute: ", now.minute


# ── Time: unix timestamp ──────────────────────────────────────────────

let t = getTime()
echo "Unix: ", t.toUnix()           # integer seconds
echo "Unix float: ", t.toUnixFloat()


# ── MonoTime: wall-clock-independent, never goes backwards ────────────

let start = getMonoTime()
var sum = 0
for i in 1..1_000_000:
  sum += i
let elapsed = getMonoTime() - start

echo "Summed 1M ints in: ", elapsed.inNanoseconds, " ns"
echo "Which is: ", elapsed.inMilliseconds, " ms"


# ── DateTime ↔ Time conversion ────────────────────────────────────────

let timeFromDt = now.toTime()
let recovered = fromUnixFloat(timeFromDt.toUnixFloat())
echo "DateTime ↔ Time round-trip OK"
