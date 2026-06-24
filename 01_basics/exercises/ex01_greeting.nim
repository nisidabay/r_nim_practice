# Exercise 1: Personal Greeting
# Write a program that asks for name and year, then prints age.
import std/[strutils, times]

echo "Name: "
let name = readLine(stdin)
echo "Birth year: "
let yearStr = readLine(stdin)
let year = parseInt(yearStr)
let currentYear = now().year
echo "Hello, ", name, ". You are ", currentYear - year, " years old."
