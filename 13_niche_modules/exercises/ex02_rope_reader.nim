# ex02_rope_reader.nim — scanf-parsed lines assembled into Rope
#   nim c -r exercises/ex02_rope_reader.nim

import std/ropes, std/strscans, std/strutils

# ── Simulated data lines ────────────────────────────────────────────────

let lines = @[
  "Item: Widget Price: 12.50",
  "Item: Gadget Price: 24.99",
  "Item: Doohickey Price: 7.49",
]

# ── Parse each line, build rope report ─────────────────────────────────

var report = rope("Purchase Report\n")
report = report & rope("================\n")

var total = 0.0

for line in lines:
  var name: string
  var price: float
  if scanf(line, "Item: $+ Price: $f", name, price):
    report = report & rope(name) & rope(": $") &
             rope($price) & rope("\n")
    total += price
  else:
    echo "Failed to parse: ", line

report = report & rope("================\n")
report = report & rope("Total: $") & rope($total) & rope("\n")

echo $report

# ── Verification ────────────────────────────────────────────────────────

let reportStr = $report
assert reportStr.contains("Widget")
assert reportStr.contains("Gadget")
assert reportStr.contains("Doohickey")
assert reportStr.contains("Total:")
assert abs(total - 44.98) < 0.001

echo "ex02_rope_reader: All assertions passed."