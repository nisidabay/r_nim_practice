# Exercise 1: Config Shell — parsecfg + terminal color demo
#   nim c -r ex01_config_shell.nim
#
# Reads a theme INI file and applies terminal colors from it.
# Demonstrates: loadConfig, getSectionValue, terminal colors

import std/parsecfg
import std/os

# ── Create a theme INI file ─────────────────────────────────────────────

let themeIni = """
[theme]
fg = fgGreen
bg = bgBlue
title = Configuration Shell
"""

let themePath = "/tmp/nim_ex01_theme.ini"
writeFile(themePath, themeIni)

# ── Load theme config ───────────────────────────────────────────────────

var cfg = loadConfig(themePath)

let fgName = cfg.getSectionValue("theme", "fg", "fgWhite")
let bgName = cfg.getSectionValue("theme", "bg", "bgBlack")
let title  = cfg.getSectionValue("theme", "title", "Untitled")

# ── Parse color names into terminal enums ───────────────────────────────

let fgCode = case fgName
  of "fgGreen": "\e[32m"
  of "fgWhite": "\e[37m"
  of "fgRed": "\e[31m"
  of "fgBlue": "\e[34m"
  of "fgYellow": "\e[33m"
  of "fgCyan": "\e[36m"
  of "fgMagenta": "\e[35m"
  of "fgBlack": "\e[30m"
  else: "\e[37m"
let bgCode = case bgName
  of "bgBlue": "\e[44m"
  of "bgBlack": "\e[40m"
  of "bgWhite": "\e[47m"
  of "bgRed": "\e[41m"
  of "bgGreen": "\e[42m"
  of "bgYellow": "\e[43m"
  of "bgCyan": "\e[46m"
  of "bgMagenta": "\e[45m"
  else: "\e[40m"

# ── Apply colors and display ───────────────────────────────────────────

stdout.write fgCode
stdout.write bgCode
echo title
stdout.write "\e[0m"

let desc = "This demo loads an INI theme file and applies its colors."
stdout.write fgCode
echo desc
stdout.write "\e[0m"

echo "\nLoaded from: ", themePath
echo "fg: ", fgName, "  bg: ", bgName

# Cleanup
removeFile(themePath)