# 12 Ecosystem & Tooling — Test It
# Combine config (parsecfg), CSV data, and structured logging.
# Uses concepts from ch12: parsecfg, parsecsv, logging.

import std/[parsecfg, parsecsv, logging, strformat, os]

# --- Logging setup ---
addHandler(newConsoleLogger(fmtStr = "[$levelid] $msg\n"))

# --- Config: write a sample INI, then parse it ---
let configPath = "/tmp/nim_test_config.ini"
writeFile(configPath, """
[colors]
name = green
score = yellow

[settings]
default_name = Guest
""")

var config = loadConfig(configPath)
let colorName = config.getSectionValue("colors", "name")
info(fmt"Config loaded: name color = {colorName}")

# --- CSV: write sample data, then parse with headers ---
let csvPath = "/tmp/nim_test_data.csv"
writeFile(csvPath, """name,score
Alice,95
Bob,82
Charlie,91
""")

var parser: CsvParser
parser.open(csvPath, separator = ',', quote = '"')
parser.readHeaderRow()

while parser.readRow():
  let name = parser.rowEntry("name")
  let score = parser.rowEntry("score")
  info(fmt"{name}: {score}")

parser.close()

# --- OOP ---
type
  Animal = ref object of RootObj
    name: string

  Dog = ref object of Animal
    breed: string

  Cat = ref object of Animal
    color: string

method speak(a: Animal): string {.base.} =
  return "..."

method speak(d: Dog): string =
  return "Woof!"

method speak(c: Cat): string =
  return "Meow!"

let pets: seq[Animal] = @[Dog(name: "Rex", breed: "Husky"), Cat(name: "Luna", color: "black")]
for p in pets:
  info(fmt"{p.name} says: {p.speak()}")

# Clean up temp files
removeFile(configPath)
removeFile(csvPath)

# Try adding a new color to the config.
# Try adding a new column to the CSV.
# Try adding a Bird type with its own speak.
