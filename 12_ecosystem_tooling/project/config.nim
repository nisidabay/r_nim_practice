# config.nim — parsecfg wrapper for [display] and [input] sections
#   Loads config.ini and exposes typed settings

import std/parsecfg
import std/strutils  # for parseEnum
import std/terminal  # for ForegroundColor, BackgroundColor

type
  DisplayConfig* = object
    fgColor*: ForegroundColor
    bgColor*: BackgroundColor
    verbosity*: string

  InputConfig* = object
    path*: string
    logFormat*: string

  AppConfig* = object
    display*: DisplayConfig
    input*: InputConfig

proc parseColor(s: string; default: ForegroundColor): ForegroundColor =
  ## Safely parse a color name from config, falling back to default
  try:
    result = parseEnum[ForegroundColor](s)
  except ValueError:
    result = default

proc parseBgColor(s: string; default: BackgroundColor): BackgroundColor =
  try:
    result = parseEnum[BackgroundColor](s)
  except ValueError:
    result = default

proc loadAppConfig*(path: string): AppConfig =
  ## Load and parse config.ini into typed AppConfig
  var cfg = loadConfig(path)

  # [display] section
  let fg = cfg.getSectionValue("display", "fg_color", "fgWhite")
  let bg = cfg.getSectionValue("display", "bg_color", "bgBlack")
  let verbosity = cfg.getSectionValue("display", "verbosity", "info")

  result.display = DisplayConfig(
    fgColor: parseColor(fg, fgWhite),
    bgColor: parseBgColor(bg, bgBlack),
    verbosity: verbosity,
  )

  # [input] section
  let inp = cfg.getSectionValue("input", "path", "log.csv")
  let fmt = cfg.getSectionValue("input", "log_format", "csv")

  result.input = InputConfig(
    path: inp,
    logFormat: fmt,
  )