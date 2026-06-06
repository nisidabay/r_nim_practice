# nim c -r count_table.nim
# CountTable counts occurrences — like Python's Counter.

import std/tables

var ct = initCountTable[string]()
ct.inc("apple")
ct.inc("apple")
ct.inc("banana")

echo ct                             # {"apple": 2, "banana": 1}
echo ct["apple"]                    # 2
echo ct.largest                     # ("apple", 2)

# From a sequence directly
let words = @["nim", "rust", "nim", "go", "nim", "rust"]
var ct2 = words.toCountTable()
echo ct2                            # {"nim": 3, "rust": 2, "go": 1}

# Sort by value
ct2.sort()
echo ct2                            # sorted by count
