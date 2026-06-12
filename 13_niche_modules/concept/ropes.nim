# std/ropes — efficient string concatenation (O(1) append)
#   nim c -r concept/ropes.nim

import std/ropes

# ── Construction ─────────────────────────────────────────────────────────

let r1 = rope("Hello")
let r2 = rope("World")

# ── Appending with & ─────────────────────────────────────────────────────

let combined = r1 & ", " & r2 & "!"
echo "Rope length: ", len(combined)
echo "Rope string: ", $combined

# ── Indexing ─────────────────────────────────────────────────────────────

echo "First char: ", combined[0]          # 'H'
echo "Seventh char: ", combined[6]        # 'W'

# ── Building piece by piece ──────────────────────────────────────────────

var builder = rope("a")
for ch in ["b", "c", "d", "e"]:
  builder = builder & ch
echo "Built: ", $builder                   # "abcde"

# ── Complexity note ──────────────────────────────────────────────────────

# Rope append is O(1) — it just creates a new internal node.
# Regular seq/string concat (s = s & "x") is O(n) — it copies the entire
# string each time. For large documents, ropes are dramatically faster.

# ── Verification ────────────────────────────────────────────────────────

assert $(rope("a") & "b" & "c") == "abc"
assert len(rope("Hello")) == 5
assert rope("Nim")[0] == 'N'

echo "All ropes assertions passed."