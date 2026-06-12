# main.nim — Modular CLI tool entry point
#   nim c -r exercises/ex03_modular_cli/main.nim [--json] [--min=N]
#
# Demonstrates multi-file project with import/export pattern.
# Uses cli_handler.nim for argument parsing and processor.nim for data.

import cli_handler, processor, std/json

# Sample dataset
var items = @[
  DataItem(name: "alpha", value: 42),
  DataItem(name: "beta", value: 17),
  DataItem(name: "gamma", value: 88),
  DataItem(name: "delta", value: 5),
  DataItem(name: "epsilon", value: 63),
]

let opts = parseArgs()

# Filter
let filtered = items.filterByValue(opts.minVal)
if filtered.len == 0:
  echo "No items match minimum value ", opts.minVal
  quit(0)

# Sort
var sorted = filtered
sorted.sortItems()

# Output
if opts.showJson:
  echo sorted.toJson().pretty()
else:
  echo "Items (value >= ", opts.minVal, "):"
  for item in sorted:
    echo "  ", item.name, ": ", item.value