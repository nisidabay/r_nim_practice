# Exercise 1: Phone Book
import std/tables

var phone = {"Carlos": "555-0101", "Ana": "555-0202"}.toTable
phone["Luis"] = "555-0303"
echo phone["Ana"]
for name, number in phone.pairs:
  echo name, ": ", number
