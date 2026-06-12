# std/parsexml — SAX-style XML/HTML event parser
#   nim c -r concept/xmlparser.nim

import std/parsexml, std/streams

# ── Parse XML from a string ─────────────────────────────────────────────

let data = "<root><item id=\"1\">Hello</item><item id=\"2\">World</item></root>"
var s = newStringStream(data)
var p: XmlParser
open(p, s, "inline")

# ── Event loop ──────────────────────────────────────────────────────────
# xmlElementStart = opening tag, xmlAttribute = key="value" pair,
# xmlCharData = text content, xmlElementEnd = closing tag

var items: seq[(string, string)]   # (id, text)
var currentId: string

while true:
  p.next()
  case p.kind
  of xmlElementStart:
    if p.elementName == "item":
      currentId = ""
    else:
      currentId = ""
  of xmlAttribute:
    if currentId.len == 0 and p.attrKey == "id":
      currentId = p.attrValue
  of xmlCharData:
    if currentId.len > 0:
      items.add (currentId, p.charData)
      currentId = ""
  of xmlEof:
    break
  else:
    discard

close(p)

# ── Output ──────────────────────────────────────────────────────────────

for (id, text) in items:
  echo "Item id=\"", id, "\" → ", text

# ── Verification ────────────────────────────────────────────────────────

assert items.len == 2
assert items[0] == ("1", "Hello")
assert items[1] == ("2", "World")

echo "All xmlparser assertions passed."