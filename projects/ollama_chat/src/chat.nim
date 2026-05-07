## Chat handling module

import std/[os, osproc, strutils, times, json, httpclient, base64, nre]
import config, environment

type
  ChatManager* = ref object
    config*: Config
    env*: Environment

proc newChatManager*(config: Config, env: Environment): ChatManager =
  result = ChatManager(config: config, env: env)

proc cleanResponse*(text: string): string =
  ## Strips ANSI escape codes and terminal artifacts.
  ## This is a direct port of: sed 's/\x1b\[[0-9;]*[mGKH]//g; s/.*\r//'

  # 1. Regex to catch ANSI sequences: ESC [ followed by parameters and a command letter
  # This covers colors (m), cursor moves (G, H, K), and screen clears (J)
  let ansiRegex = re"\e\[[0-9;]*[a-zA-Z]"
  var scrubbed = text.replace(ansiRegex, "")

  # 2. Handle Carriage Returns (\r)
  # Ollama uses \r to perform "in-place" updates for the spinner.
  # We split by line, then for each line, split by \r and keep only the last segment.
  var finalLines: seq[string] = @[]
  for line in scrubbed.splitLines():
    if line.contains('\r'):
      let parts = line.split('\r')
      let lastPart = parts[^1].strip(leading = true, trailing = false)
      if lastPart.len > 0:
        finalLines.add(lastPart)
    else:
      finalLines.add(line)

  result = finalLines.join("\n").strip()

proc getHistory*(cm: ChatManager): string =
  if fileExists(cm.config.chatHistoryFile):
    result = readFile(cm.config.chatHistoryFile)
  else:
    result = ""

proc clearHistory*(cm: ChatManager) =
  writeFile(cm.config.chatHistoryFile, "")
  echo "📜 History has been cleared."

proc appendToHistory*(cm: ChatManager, userInput, response: string) =
  let entry = "👦 You: " & userInput & "\n\n🤖 AI: " & response & "\n\n"
  let f = open(cm.config.chatHistoryFile, fmAppend)
  f.write(entry)
  f.close()

proc sendChat*(cm: ChatManager, userInput: string): string =
  ## Send a chat message to Ollama and get response
  let history = cm.getHistory()
  let fullPrompt = if history.len > 0:
                     history & "\n\nUser request: " & userInput
                   else:
                     "User request: " & userInput

  echo "🧠 Thinking..."

  # Run the command and capture output
  let cmd = "ollama run " & quoteShell(cm.config.model) & " " & quoteShell(fullPrompt)
  let (output, exitCode) = execCmdEx(cmd)

  if exitCode == 0 and output.strip().len > 0:
    # APPLY THE CLEANING LOGIC
    result = cleanResponse(output)

    # Append to history
    cm.appendToHistory(userInput, result)
    # Copy to clipboard
    cm.env.copyToClipboard(result)
    # Notify
    discard execCmd("notify-send -u normal 'Chat' 'Ollama replied!' --icon=dialog-information")
  else:
    result = ""

proc getAvailableModels*(cm: ChatManager): seq[string] =
  ## Get list of available Ollama models
  let (output, exitCode) = execCmdEx("ollama list")
  if exitCode == 0:
    for line in output.splitLines()[1..^1]: # Skip header
      let parts = line.splitWhitespace()
      if parts.len > 0:
        result.add(parts[0])

proc switchModel*(cm: ChatManager): string =
  ## Switch to a different model
  let models = cm.getAvailableModels()
  if models.len == 0:
    echo "❌ No models available."
    return cm.config.model

  let selected = cm.env.showMenu("Select Ollama Model: ", models)
  if selected.len > 0:
    result = selected
  else:
    result = cm.config.model

proc stopModel*(cm: ChatManager) =
  if cm.config.model.len > 0:
    discard execCmd("ollama stop " & quoteShell(cm.config.model) & " 2>/dev/null")

proc restartOllamaServer*() =
  let (_, exitCode) = execCmdEx("pgrep -x ollama")
  if exitCode == 0:
    echo "🛑 Shutting down Ollama server..."
    if execCmd("sudo pkill ollama") == 0:
      echo "✅ Ollama server has been shut down."
      echo "✅ Ollama will be restarted automatically."
    else:
      echo "❌ Failed to shut down Ollama server. Check sudo permissions."
  else:
    echo "🔴 Ollama server is not running."

proc getLastResponse*(cm: ChatManager): string =
  ## Extract the last AI response from history
  let history = cm.getHistory()
  if history.len == 0:
    return ""

  let lines = history.split("🤖 AI:")
  if lines.len > 1:
    let lastPart = lines[^1]
    let endIdx = lastPart.find("👦 You:")
    if endIdx > 0:
      result = lastPart[0..<endIdx].strip()
    else:
      result = lastPart.strip()
