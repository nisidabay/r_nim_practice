## Configuration module for Ollama Chat

import std/[os, strutils, tables]

type
  Config* = object
    model*: string
    editor*: string
    pager*: string
    scriptDir*: string
    configFile*: string
    chatHistoryFile*: string
    imageDir*: string
    webSearchPath*: string
    searchEngines*: Table[string, string]

const
  Version* = "1.4.1"
  DefaultModel* = "ministral-3:8b"
  DefaultEditor* = "nvim"
  DefaultPager* = "nvim"

proc getDefaultSearchEngines*(): Table[string, string] =
  result = {
    "brave": "https://search.brave.com/search?q=",
    "google": "https://www.google.com/search?q=",
    "duck": "https://duckduckgo.com/?q=",
    "wikipedia": "https://en.wikipedia.org/wiki/",
    "github": "https://github.com/search?q="
  }.toTable

proc loadConfig*(configPath: string = ""): Config =
  let homeDir = getHomeDir()
  result.scriptDir = homeDir / "bin" / "ollama_chat"
  result.configFile = if configPath.len > 0: configPath
                      else: result.scriptDir / "ollama_explain.conf"
  result.chatHistoryFile = result.scriptDir / ".ollama_explain_history.log"
  result.imageDir = homeDir / "Pictures" / "Screenshots"
  result.webSearchPath = result.scriptDir / "web_search"

  # Default values
  result.model = DefaultModel
  result.editor = DefaultEditor
  result.pager = DefaultPager
  result.searchEngines = getDefaultSearchEngines()

  # Create history file if it doesn't exist
  if not fileExists(result.chatHistoryFile):
    try:
      createDir(result.scriptDir)
      writeFile(result.chatHistoryFile, "")
    except OSError:
      discard

  # Load config file if exists
  if fileExists(result.configFile):
    try:
      let content = readFile(result.configFile)
      for line in content.splitLines():
        let trimmed = line.strip()
        if trimmed.len == 0 or trimmed.startsWith("#"):
          continue

        if trimmed.contains("="):
          let parts = trimmed.split("=", 1)
          if parts.len == 2:
            let key = parts[0].strip()
            var value = parts[1].strip()
            if value.startsWith("\"") and value.endsWith("\""):
              value = value[1..^2]

            case key.toLowerAscii()
            of "model": result.model = value
            of "editor": result.editor = value
            of "pager": result.pager = value
            else: discard
    except IOError:
      discard

proc saveModel*(config: var Config, model: string) =
  config.model = model
  var lines: seq[string] = @[]
  var modelFound = false

  if fileExists(config.configFile):
    for line in readFile(config.configFile).splitLines():
      if line.strip().startsWith("MODEL="):
        lines.add("MODEL=\"" & model & "\"")
        modelFound = true
      else:
        lines.add(line)

  if not modelFound:
    lines.add("MODEL=\"" & model & "\"")

  try:
    writeFile(config.configFile, lines.join("\n"))
  except IOError:
    echo "❌ Failed to save configuration file."
