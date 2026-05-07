## Ollama Chat - Local AI chat interface
## 
## A Nim port of ollama_explain.sh
## Supports both X11 and Wayland environments

import std/[os, strutils, terminal, osproc]
import config, environment, chat, commands, vision

proc main() =
  # Load configuration
  var cfg = loadConfig()

  # Setup environment (detect Wayland/X11)
  let env = setupEnvironment()

  # Check core dependencies
  let missing = checkDependencies(["ollama", "nvim", "fzf", "jq", "file", "curl"])
  if missing.len > 0:
    quit("❌ Missing dependencies: " & missing.join(", "), 1)

  # Create chat manager
  var cm = newChatManager(cfg, env)

  # Display header
  echo "-------------------------------------"
  echo "🦙 Ollama explains. Local chat 🦙"
  echo "🧠 Using model: '" & cfg.model & "'"
  echo "⌨  Type '!menu' for commands."
  let tmuxWarning = showTmuxWarning()
  if tmuxWarning.len > 0:
    echo tmuxWarning
  echo "-------------------------------------"
  echo ""

  # Ensure model is set
  if cfg.model.len == 0:
    cfg.model = cm.switchModel()
    cfg.saveModel(cfg.model)

  # Main interactive loop
  while true:
    # Visual prompt
    let visualPrompt = if env.isTmux: "\e[31m👦 \e[0m" else: "👦 "
    stdout.write(visualPrompt)
    stdout.flushFile()

    # Read input
    var userInput: string
    try:
      userInput = stdin.readLine().strip()
    except EOFError:
      break

    # Clean input
    userInput = userInput.replace("You:", "").strip()

    # Skip empty input
    if userInput.len == 0:
      echo "⚠️ Empty input."
      continue

    # Handle commands
    case userInput.toLowerAscii()
    of "exit", "quit":
      cm.stopModel()
      echo "👋 Goodbye!"
      break

    of "!menu", "!m":
      showMenu(Version)

    of "!history", "!his":
      handleHistory(cm)

    of "!clear":
      cm.clearHistory()

    of "!new_chat", "!new":
      cm.clearHistory()
      eraseScreen()
      setCursorPos(0, 0)

    of "!kill", "!k":
      restartOllamaServer()
      break

    of "!switch", "!sw":
      let oldModel = cfg.model
      let newModel = cm.switchModel()
      if newModel != oldModel:
        discard execCmd("ollama stop " & quoteShell(oldModel) & " 2>/dev/null")
        cfg.model = newModel
        cfg.saveModel(newModel)
        cm.config = cfg
        echo "🧠 Switched to " & newModel

    of "!save", "!sa":
      handleSave(cm)

    of "!load", "!lo":
      eraseScreen()
      setCursorPos(0, 0)
      handleLoad(cm)

    of "!last":
      handleLast(cm)

    of "!rm":
      handleRemove(cm)

    of "!web":
      handleWeb(cm)

    of "!terminal", "!t":
      launchTerminal(env)

    of "!edit_saved", "!es":
      handleEditSaved(cm)

    of "!vision", "!img":
      handleVision(cm)

    else:
      # Regular chat input
      let response = cm.sendChat(userInput)
      if response.len > 0:
        echo ""
        echo "🤖 AI: " & response
        echo ""
        echo "-----------------------------------------------"
        echo "📋 Response copied to clipboard."
        echo "📜 The whole chat is available with !history"
        if env.isTmux:
          echo showTmuxWarning()
        echo "-----------------------------------------------"
      else:
        echo "⚠️ Warning: Ollama returned an empty or filtered-out response."

when isMainModule:
  main()
