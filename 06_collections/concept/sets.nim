# sets — bitsets and hash sets
#   import std/sets (for HashSet, OrderedSet)
#   set[T] is built-in (no import needed)
#   NOTE: set[T], HashSet[T] use generics — see Module 09.

import std/sets

# ── set[T]: bitset — super fast, max 2^16 elements ────────────────────

# Character sets (common for parsers):
var chars: set[char] = {'a', 'e', 'i', 'o', 'u'}
echo 'e' in chars                # true
echo 'x' in chars                # false

chars.incl('y')                  # add
chars.excl('a')                  # remove

# Set algebra on ordinal types:
let lowercase = {'a'..'z'}
let vowels = {'a', 'e', 'i', 'o', 'u'}
echo vowels * lowercase          # intersection
echo vowels + {'y'}             # union
echo lowercase - vowels          # difference


# ── Enum sets: flags and permissions ──────────────────────────────────

type Permission = enum
  permRead, permWrite, permExecute

var
  owner: set[Permission] = {permRead, permWrite, permExecute}
  group: set[Permission] = {permRead, permExecute}

echo permWrite in owner          # true
echo permWrite in group          # false
echo owner - group               # {permWrite}


# ── HashSet[T]: dynamic, any hashable type ────────────────────────────

var names: HashSet[string]
names.incl("carlos")
names.incl("alice")
names.incl("bob")
echo "alice" in names            # true
echo names.card                  # 3

# Set operations on HashSet:
var others = ["zoe", "alice"].toHashSet()
echo names * others              # intersection: {"alice"}
echo names + others              # union: {"carlos", "alice", "zoe"}
echo names - others              # difference: {"carlos"}

# Dedup via HashSet:
let fruits = @["apple", "banana", "cherry", "apple"]
echo fruits.toHashSet()          # {"banana", "apple", "cherry"}


# ── When to use which ─────────────────────────────────────────────────
# set[T]:   flags, chars, enums — zero allocation, compile-time capable
# HashSet:  strings, objects, dynamic size — heap-allocated, any type

# ── Thinking in Nim ────────────────────────────
# Nim has two: set[T] is a compile-time-capable bitset (max 2^16 elems,
# perfect for char/enum flags), while HashSet[T] is dynamic and holds any
# hashable type. Both share the same + * - membership algebra.
