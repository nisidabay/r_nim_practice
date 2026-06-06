# re — regular expressions (PCRE-backed)
#   import std/re

import std/re

# ── re"" creates compiled patterns ────────────────────────────────────

let emailPat = re"[a-z]+@[a-z]+\.[a-z]+"
echo "carlos@nim.org".contains(emailPat)   # true
echo "bad-email".contains(emailPat)        # false


# ── find: returns slice bounds ────────────────────────────────────────

echo "score: 42".find(re"\d+")   # 7..8

let line = "Contact: carlos@nim.org or alice@nim.dev"
let bounds = line.find(emailPat)
echo line[bounds]                # "carlos@nim.org"


# ── findAll: collects all matches ─────────────────────────────────────

for m in line.findAll(emailPat):
  echo m   # carlos@nim.org, alice@nim.dev


# ── match: full-string match (anchored) ───────────────────────────────

echo "abc123".match(re"[a-z]+\d+")   # true
echo "abc123".match(re"\d+")         # false — must match FROM start


# ── replace: substitute matches ───────────────────────────────────────

echo "I like cats".replace(re"cats", "dogs")   # "I like dogs"
echo "a    b   c".replace(re"\s+", " ")        # "a b c"


# ── split by regex ────────────────────────────────────────────────────

echo "one, two; three".split(re"[,;]\s*")   # @["one", "two", "three"]


# ── Capturing groups ──────────────────────────────────────────────────

let datePat = re"(\d{4})-(\d{2})-(\d{2})"
let date = "2026-05-06"

var m: array[4, string]
if date.match(datePat, m):
  echo "Year: ", m[1]     # "2026"
  echo "Month: ", m[2]    # "05"
  echo "Day: ", m[3]      # "06"


# ── Swap using capture groups ─────────────────────────────────────────

echo "Smith, John".replace(re"(\w+),\s*(\w+)", "$2 $1")  # "John Smith"


# ── Flags: case-insensitive, multiline ────────────────────────────────

echo "HELLO".match(re"(?i)hello")      # true — (?i) = ignore case
echo "NIM\nrocks".contains(re"(?m)^rocks")  # true — (?m) = multiline
