# configreader.nim — JSON config loader with path resolution
#   import configreader
#
# Reads ~/.nimrinfo JSON config and provides path resolution (expanding ~).

import std/[json, os, strutils]

proc loadConfig*(path: string): JsonNode =
  ## Parse a JSON file and return the root node.
  ## Returns `newJNull()` if the file doesn't exist or is invalid.
  if not fileExists(path):
    return newJNull()
  try:
    result = parseJson(readFile(path))
  except:
    result = newJNull()

proc resolvePath*(section: string): string =
  ## Resolve a section name to a filesystem path.
  ## Expands `~` to the home directory, else returns the section as-is.
  if section.startsWith("~/"):
    result = getHomeDir() / section[2..^1]
  elif section == "~":
    result = getHomeDir()
  else:
    result = section

when isMainModule:
  # Demo
  let cfg = loadConfig(getHomeDir() / ".nimrinfo")
  echo "Config loaded: ", cfg.kind == JNull
  echo "resolvePath('~/tests'): ", resolvePath("~/tests")