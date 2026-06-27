# a.b(c) means exactly b(a, c). Any function works this way.
# It's NOT OOP inheritance — it's purely syntax. Pipeline your calls.

import std/strutils

# ── Functions on config strings ───────────────────────────────────────

proc stripComments(s: string): string =
  let pos = s.find('#')
  if pos >= 0: s[0 ..< pos] else: s

proc collapseSpaces(s: string): string =
  result = s.strip()
  while result.contains("  "):
    result = result.replace("  ", " ")

proc defaultTo(s: string, fallback: string): string =
  if s.len == 0: fallback else: s

# Without UFCS: inside-out
let raw = "  port=8080  # main   "
echo defaultTo(collapseSpaces(stripComments(raw)), "port=3000")

# With UFCS: left-to-right pipeline
echo raw.stripComments().collapseSpaces().defaultTo("port=3000")


# ── Built-in procs chain too ──────────────────────────────────────────

let username = "  Carlos  "
echo username.strip().toUpperAscii() # "CARLOS"
echo username.strip().replace("a", "@") # "C@rlos"


# ── Multiple arguments: first arg becomes receiver ────────────────────

proc truncate(s: string, maxLen: int): string =
  if s.len <= maxLen: s else: s[0 ..< maxLen]

let desc = "A very long description of a Nim feature"
echo desc.truncate(20) # "A very long descrip"
echo truncate(desc, 20) # same thing
