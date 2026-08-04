# std/json — parsing, construction, serialization, roundtrip
#   nim c -r concept/json.nim

import std/json

# ── Parsing ──────────────────────────────────────────────────────────────

let raw = """{"name": "Nim", "version": 2.2, "tags": ["systems", "fast"]}"""
let node = parseJson(raw)
echo "Parsed name: ", node["name"]                     # "Nim"
echo "Parsed version: ", node["version"]               # 2.2
echo "First tag: ", node["tags"][0]                    # "systems"

# ── Construction with %* macro ───────────────────────────────────────────

let arr = %*[1, 2, 3, 4, 5]
echo "%* array: ", arr                                 # [1, 2, 3, 4, 5]

let obj = %*{"name": "Nim", "year": 2025}
echo "%* object: ", obj                                # {"name":"Nim","year":2025}

# ── Literal construction with {} / [] ────────────────────────────────────

var user = newJObject()
user["id"] = %(42)
user["active"] = %(true)
echo "user: ", user                                    # {"id":42,"active":true}

var items = newJArray()
items.add(%("alpha"))
items.add(%("beta"))
echo "items: ", items                                  # ["alpha","beta"]

# ── Serialization ────────────────────────────────────────────────────────

echo "compact: $ = ", $obj                             # {"name":"Nim","year":2025}
echo "pretty():"
echo pretty(obj)                                       # multi-line format

# ── Roundtrip ────────────────────────────────────────────────────────────

let original = %*{"x": 10, "y": 20}
let serial = $original
let back = parseJson(serial)
echo "roundtrip matches: ", original == back           # true

# ── Thinking in Nim ────────────────────────────
# Nim's JSON support is first-class: %* builds nodes with Nim-native
# syntax, %() wraps any value, and `$` serializes back. The same JsonNode
# tree parses, builds, and roundtrips — no separate writer declaration.
