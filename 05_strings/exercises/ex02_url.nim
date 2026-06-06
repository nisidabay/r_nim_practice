# Exercise 2: URL Parser
import std/strutils

let url = "https://nim-lang.org/docs/strutils.html"
let protocol = url.split("://")[0]
let rest = url.split("://")[1]
let host = rest.split('/')[0]
let path = "/" & rest.split('/', maxsplit=1)[1]
echo "Protocol: ", protocol
echo "Host:     ", host
echo "Path:     ", path
