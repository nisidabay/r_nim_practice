# random — random numbers, shuffle, sample
#   import std/random

import std/random
randomize()  # seed once at program start

# ── rand(n) — random integer ──────────────────────────────────────────────

let dice = rand(1..6)         # roll a die: int in 1..6
let coin = rand(1..2)         # 1 or 2
let zeroToNine = rand(9)      # int in 0..9
doAssert dice in 1..6
doAssert coin in 1..2
doAssert zeroToNine in 0..9

# ── rand(n) — random float ────────────────────────────────────────────────

let frac = rand(1.0)          # float in 0.0..1.0
doAssert frac in 0.0..1.0

# ── sample — random element ───────────────────────────────────────────────

let colors = @["red", "green", "blue"]
let pick = sample(colors)      # random element
doAssert pick in colors

# ── shuffle — random permutation ──────────────────────────────────────────

var deck = @[1, 2, 3, 4, 5]
deck.shuffle()
doAssert deck.len == 5
doAssert 1 in deck and 5 in deck

# ── Thinking in Nim ────────────────────────────
# Nim's random module is deliberately small: call randomize() once, then
# rand(1..6) gives a die roll, rand(1.0) a float, sample picks an element,
# and shuffle permutes in place. Ranges make the API type-safe and readable.
