# Exercise 1: Personal Greeting
# Write a program that asks for name and year, then prints age.
import std/strutils

echo "Name: "
let name = readLine(stdin)
echo "Birth year: "
let yearStr = readLine(stdin)
let year = parseInt(yearStr)
echo "Hello, ", name, ". You are ", 2026 - year, " years old."
