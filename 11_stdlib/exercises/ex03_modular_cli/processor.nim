# processor.nim — Data processing module for the modular CLI tool
# Uses std/algorithm for sorting and std/json for data output.

import std/[algorithm, json]

type
  DataItem* = object
    name*: string
    value*: int

proc sortItems*(items: var seq[DataItem]) =
  ## Sort items by value descending.
  items.sort(cmp = proc(a, b: DataItem): int =
    cmp(b.value, a.value))

proc filterByValue*(items: openArray[DataItem], minVal: int): seq[DataItem] =
  ## Return items with value >= minVal.
  result = @[]
  for item in items:
    if item.value >= minVal:
      result.add(item)

proc toJson*(items: openArray[DataItem]): JsonNode =
  ## Convert items to JSON array.
  result = newJArray()
  for item in items:
    result.add(%*{"name": item.name, "value": item.value})