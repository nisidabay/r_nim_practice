# sequtils — map, filter, fold, zip on sequences
#   import std/sequtils
#
# ── This is functional programming ────────────────────────────────────
# map / filter / fold come from functional programming. The idea:
#   • Don't mutate data — transform it
#   • Pure functions: same input → same output
#   • Compose operations: pipeline with UFCS (Module 03)
#
# Nim supports this via:
#   • func     — compile-time pure (Module 03)
#   • let      — immutable bindings (Module 01)
#   • sequtils — map, filter, fold, zip
#   • UFCS     — chain operations: data.map(f).filter(g)
#
# You don't NEED to write functional code in Nim. But when you do,
# it's cleaner, safer, and often shorter.
# ─────────────────────────────────────────────────────────────────────

import std/sequtils

let numbers = @[1, 2, 3, 4, 5, 6, 7, 8]

# ── map: transform each element ───────────────────────────────────────

# This `proc(x: int): int = x * 2` is an anonymous (inline) proc — a function
# value passed directly as an argument. Procs are first-class values in Nim.
# See Module 03 for proc basics.
echo numbers.map(proc(x: int): int = x * 2) # @[2, 4, 6, 8, 10, 12, 14, 16]
echo numbers.map(proc(x: int): int = x * 3) # @[3, 6, 9, 12, 15, 18, 21, 24]


# ── filter: keep matching elements ────────────────────────────────────

echo numbers.filter(proc(x: int): bool = x mod 2 == 0) # @[2, 4, 6, 8]
echo numbers.filter(proc(x: int): bool = x > 4) # @[5, 6, 7, 8]


# ── keepIf: mutable filter (remove non-matching) ──────────────────────

var mutable = @[10, 11, 12, 13, 14, 15]
mutable.keepIf(proc(x: int): bool = x mod 2 == 0)
echo mutable # @[10, 12, 14]


# ── fold: reduce to single value ─────────────────────────────────────

var sum = 0
for n in numbers:
  sum += n
echo sum # 36 — sum

var product = 1
for n in numbers:
  product *= n
echo product # 40320 — product


# ── concat: join sequences ────────────────────────────────────────────

let a = @[1, 2, 3]
let b = @[4, 5, 6]
echo concat(a, b) # @[1, 2, 3, 4, 5, 6]


# ── zip / unzip: pair and unpair ──────────────────────────────────────

let names = @["carlos", "alice", "bob"]
let scores = @[100, 85, 72]
let namesScoresZipped = zip(names, scores)
echo namesScoresZipped

let (people, grades) = unzip(namesScoresZipped)
echo people
echo grades

# ── deduplicate: remove consecutive duplicates ────────────────────────

echo @[1, 1, 2, 2, 2, 3, 1].deduplicate() # @[1, 2, 3, 1]


# ── all / any / count ─────────────────────────────────────────────────

echo numbers.all(proc(x: int): bool = x > 0) # true
echo numbers.any(proc(x: int): bool = x > 7) # true
echo numbers.any(proc(x: int): bool = x mod 2 == 0) # true

var countEven = 0
for n in numbers:
  if n mod 2 == 0:
    inc countEven
echo countEven # 4


# ── Pipeline style: odds → squares → sum ──────────────────────────────

var result = 0
for n in numbers:
  if n mod 2 == 1: # odds
    result += n * n # square and accumulate

echo result # 84

# ── Thinking in Nim ────────────────────────────
# sequtils brings map/filter/fold/zip — pure, composable transforms —
# and UFCS lets you chain them naturally. Procs are first-class values,
# so anonymous inline procs pass straight into these combinators.
