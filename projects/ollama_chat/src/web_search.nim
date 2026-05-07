## Web Search - Helper for Ollama Chat
## 
## Provides search engine selection and URL launching

import std/[os, osproc, strutils, tables]
import config, environment

proc main() =
  # Load configuration
  let cfg = loadConfig()

  # Setup environment
  let env = setupEnvironment()

  # Get search engines
  let searchEngines = cfg.searchEngines

  # Get query from user via menu
  let query = env.showMenu("🔍 Search what? > ", @[""])
  if query.len == 0:
    echo "Failed to get the query"
    return

  # Show engine selection
  var engineNames: seq[string] = @[]
  for name in searchEngines.keys:
    engineNames.add(name)

  let selectedEngine = env.showMenu("Select Engine: ", engineNames)
  if selectedEngine.len == 0:
    return

  if not searchEngines.hasKey(selectedEngine):
    echo "Invalid engine selected."
    return

  # Build URL
  let url = searchEngines[selectedEngine] & query

  # Open in browser
  if execCmd("firefox " & quoteShell(url) & " >/dev/null 2>&1") != 0:
    discard execCmd("xdg-open " & quoteShell(url) & " >/dev/null 2>&1")

when isMainModule:
  main()
