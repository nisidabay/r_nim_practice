# tables — hash maps, ordered maps, counters
#   import std/tables

import std/[tables, strutils, hashes]

# ── Table: basic hash map ─────────────────────────────────────────────

var scores = {"carlos": 100, "alice": 85, "bob": 72}.toTable()
echo scores["carlos"]            # 100
# echo scores["zoe"]              # KeyError at runtime!

# Safe access:
echo scores.getOrDefault("zoe", 0)  # 0


# ── Presence checks ───────────────────────────────────────────────────

echo scores.hasKey("alice")       # true
echo "bob" in scores              # true
echo scores.hasKeyOrPut("zoe", 50)  # false — adds zoe = 50
echo scores["zoe"]                # 50


# ── Iteration ─────────────────────────────────────────────────────────

for key, value in scores.pairs():
  echo key, ": ", value

for key in scores.keys():
  echo key


# ── Mutating ──────────────────────────────────────────────────────────

scores["alice"] = 90             # overwrite
scores.del("bob")                # remove
echo "bob" in scores              # false

# mgetOrPut: get or insert default, then return mutable ref
var counters: Table[string, int]
counters.mgetOrPut("requests", 0).inc()
echo counters["requests"]         # 1


# ── From array ────────────────────────────────────────────────────────

let pairs = [("a", 1), ("b", 2), ("c", 3)]
let t = pairs.toTable()
echo t["a"]


# ── OrderedTable: insertion order preserved ──────────────────────────

var ordered = {"z": 1, "a": 2, "m": 3}.toOrderedTable()
for k in ordered.keys():
  echo k   # z, a, m


# ── CountTable: histogram ─────────────────────────────────────────────

var wordCounts: CountTable[string]
wordCounts.inc("nim")
wordCounts.inc("nim")
wordCounts.inc("rust")
echo wordCounts["nim"]            # 2
echo wordCounts.largest()         # ("nim", 2)

# Count from sequence directly:
let words = "nim is fast nim is safe".split()
var freq = words.toCountTable()
echo freq["nim"]                   # 2

# Count characters:
var letterCounts = "mississippi".toCountTable()
echo letterCounts['s']             # 4


# ── TableRef: heap-allocated, shared by reference ─────────────────────

var refTable = newTable[string, int]()
refTable["answer"] = 42


# ── Grouping by key ───────────────────────────────────────────────────

# NOTE: `object` is a structured type with named fields (like a struct in C).
# Objects are covered in depth in Module 09.
type Person = object
  name: string
  dept: string

let people = @[
  Person(name: "Carlos", dept: "eng"),
  Person(name: "Alice", dept: "design"),
  Person(name: "Bob", dept: "eng"),
]

import sequtils
var byDept: Table[string, seq[Person]]
for p in people:
  byDept.mgetOrPut(p.dept, @[]).add(p)

echo byDept["eng"].mapIt(it.name)  # @["Carlos", "Bob"]


# ── Object keys: needs a hash proc ────────────────────────────────────

type Point = object
  x, y: int

proc hash(p: Point): Hash =
  hash(p.x) xor hash(p.y)

var grid: Table[Point, string]
grid[Point(x: 0, y: 0)] = "origin"
grid[Point(x: 5, y: 3)] = "target"
echo grid[Point(x: 5, y: 3)]      # "target"
