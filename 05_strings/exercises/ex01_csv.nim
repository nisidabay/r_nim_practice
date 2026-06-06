# Exercise 1: CSV Parser
import std/strutils

let line = "Carlos,42,Madrid"
let fields = line.split(',')
echo fields

# Trim and align
echo "Name".alignLeft(12), "Age", "City"
for f in fields:
  write(stdout, f.strip().alignLeft(12))
echo ""
