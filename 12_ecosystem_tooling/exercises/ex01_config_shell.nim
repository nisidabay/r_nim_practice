# Exercise 1: Config Shell — parsecfg + terminal color demo
#   nim c -r ex01_config_shell.nim
#
# Reads a theme INI file and applies terminal colors from it.
# Demonstrates: loadConfig, getSectionValue, terminal colors

import std/parsecfg
import std/os
import std/terminal
import std/strutils

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

let fgColor = parseEnum[ForegroundColor](fgName)
let bgColor = parseEnum[BackgroundColor](bgName)

# ── Apply colors and display ───────────────────────────────────────────

setForegroundColor(fgColor)
setBackgroundColor(bgColor)
echo title
resetAttributes()

let desc = "This demo loads an INI theme file and applies its colors."
setForegroundColor(fgColor)
echo desc
resetAttributes()

echo "\nLoaded from: ", themePath
echo "fg: ", fgName, "  bg: ", bgName

# Cleanup
removeFile(themePath)