# sequtils — map, filter, fold, zip on sequences
#   import std/sequtils

import std/sequtils

let numbers = @[1, 2, 3, 4, 5, 6, 7, 8]

# ── map: transform each element ───────────────────────────────────────

echo numbers.map(proc(x: int): int = x * 2)   # @[2, 4, 6, 8, 10, 12, 14, 16]
echo numbers.mapIt(it * 3)                     # @[3, 6, 9, 12, 15, 18, 21, 24]


# ── filter: keep matching elements ────────────────────────────────────

echo numbers.filter(proc(x: int): bool = x mod 2 == 0)  # @[2, 4, 6, 8]
echo numbers.filterIt(it > 4)                            # @[5, 6, 7, 8]


# ── keepIf: mutable filter (remove non-matching) ──────────────────────

var mutable = @[10, 11, 12, 13, 14, 15]
mutable.keepIf(proc(x: int): bool = x mod 2 == 0)
echo mutable                    # @[10, 12, 14]


# ── foldl: reduce to single value ─────────────────────────────────────

echo numbers.foldl(a + b)         # 36 — sum (a = accum, b = elem)
echo numbers.foldl(a * b)         # 40320 — product


# ── concat: join sequences ────────────────────────────────────────────

let a = @[1, 2, 3]
let b = @[4, 5, 6]
echo concat(a, b)                # @[1, 2, 3, 4, 5, 6]


# ── zip / unzip: pair and unpair ──────────────────────────────────────

let names = @["carlos", "alice", "bob"]
let scores = @[100, 85, 72]
echo zip(names, scores)          # @[("carlos", 100), ("alice", 85), ("bob", 72)]

let paired = @[("a", 1), ("b", 2)]
let (letters, digits) = unzip(paired)
echo letters   # @["a", "b"]
echo digits    # @[1, 2]


# ── deduplicate: remove consecutive duplicates ────────────────────────

echo @[1, 1, 2, 2, 2, 3, 1].deduplicate()   # @[1, 2, 3, 1]


# ── all / any / count ─────────────────────────────────────────────────

echo numbers.allIt(it > 0)       # true
echo numbers.anyIt(it > 7)       # true
echo numbers.countIt(it mod 2 == 0)  # 4


# ── Pipeline style: chain with UFCS ───────────────────────────────────

let result = numbers
  .filterIt(it mod 2 == 1)       # odds: [1, 3, 5, 7]
  .mapIt(it * it)                # squares: [1, 9, 25, 49]
  .foldl(a + b)                  # sum: 84

echo result   # 84
