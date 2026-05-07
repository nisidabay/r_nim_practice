## Command handling module

import std/[os, osproc, strutils, times, algorithm]
import config, environment, chat

proc showMenu*(version: string) =
  echo """
---------------------------------------------------
--- Ollama Explains Menu ---
Version: """ & version & """

---------------------------------------------------

Usage
  !menu | !m         - Show this help menu.

Manage history
  !clear             - Clear the chat history.
  !history | !his    - View the chat history.
  !last              - Copy last prompt to clipboard.

Manage chat
  !load | !lo        - Load selected chat to history.
  !save | !sa        - Save current chat.
  !edit_saved | !es  - Edit a previously saved chat.
  !new_chat | !new   - Start a new chat. Clear the history.
  !rm                - Remove selected chat.

Manage models
  !switch | !sw      - Change current AI model on the fly.

Manage helpers
  !web               - Search the web.
  !terminal | !t     - Launch a new detached terminal.
  !vision | !img     - Analyze image (JPG/PNG only).

Manage script
  !kill | !k         - Stop the Ollama process and exit.
  exit | quit        - Quit the script.

Manage clipboard
Paste text to the chat
  Paste a block of text and press Ctrl+D to submit.

---------------------------------------------------
"""

proc handleHistory*(cm: ChatManager) =
  let history = cm.getHistory()
  if history.len > 0:
    # Use pager to view history
    let tmpFile = getTempDir() / "ollama_history-" & $epochTime().int & ".txt"
    writeFile(tmpFile, history)
    discard execCmd(cm.config.pager & " " & quoteShell(tmpFile))
    removeFile(tmpFile)
  else:
    echo "📜 History is empty."

proc handleSave*(cm: ChatManager) =
  stdout.write "💾 Save current chat? (y/N) "
  let confirm = stdin.readLine().toLowerAscii()
  if confirm.startsWith("y"):
    stdout.write "💾 Save session as (default: chat-" & now().format(
        "yyyyMMdd:HHmm") & ".txt): "
    var filename = stdin.readLine().strip()
    if filename.len == 0:
      filename = "chat-" & now().format("yyyyMMdd:HHmm") & ".txt"
    if not filename.endsWith(".txt"):
      filename &= ".txt"

    let dest = cm.config.scriptDir / filename
    try:
      copyFile(cm.config.chatHistoryFile, dest)
      echo "✅ Saved to " & dest
    except IOError:
      echo "❌ Failed to save session"

proc getSavedChats*(cm: ChatManager): seq[string] =
  result = @[]
  for kind, path in walkDir(cm.config.scriptDir):
    if kind == pcFile and path.endsWith(".txt"):
      result.add(path)
  result.sort()

proc handleLoad*(cm: ChatManager) =
  let chats = getSavedChats(cm)
  if chats.len == 0:
    echo "📜 No chat sessions available to restore."
    return

  let selected = cm.env.showMenu("Restore chat session: ", chats)
  if selected.len == 0:
    echo "📜 No chat selected."
    return

  if not fileExists(selected):
    echo "❌ No chat found: " & selected
    return

  try:
    copyFile(selected, cm.config.chatHistoryFile)
    echo "✅ Session restored from " & extractFilename(selected)
  except IOError:
    echo "❌ Failed to restore session"

proc handleRemove*(cm: ChatManager) =
  let chats = getSavedChats(cm)
  if chats.len == 0:
    echo "📜 No chat sessions available to remove."
    return

  let selected = cm.env.showMenu("Remove chat: ", chats)
  if selected.len == 0:
    echo "📜 No chat selected."
    return

  if not fileExists(selected):
    echo "❌ File not found: " & selected
    return

  stdout.write "🧹 Remove selected chat? (y/N) "
  let confirm = stdin.readLine().toLowerAscii()
  if confirm.startsWith("y"):
    try:
      removeFile(selected)
      echo "✅ Chat removed"
    except IOError:
      echo "❌ Failed to remove chat"

proc handleEditSaved*(cm: ChatManager) =
  let chats = getSavedChats(cm)
  if chats.len == 0:
    echo "📜 No chat sessions available to edit."
    return

  let selected = cm.env.showMenu("Edit chat session: ", chats)
  if selected.len == 0:
    echo "📜 No chat selected."
    return

  if not fileExists(selected):
    echo "❌ File not found: " & selected
    return

  echo "✏️ Opening '" & selected & "' in '" & cm.config.pager & "'..."
  discard execCmd(cm.config.pager & " " & quoteShell(selected))
  echo "✅ Edit session ended."

proc handleLast*(cm: ChatManager) =
  let lastResponse = cm.getLastResponse()
  if lastResponse.len > 0:
    cm.env.copyToClipboard(lastResponse)
    echo "📋 Last prompt copied to clipboard."
  else:
    echo "📜 No previous prompt found."

proc handleWeb*(cm: ChatManager) =
  ## Launch web search in detached process
  let webSearchPath = cm.config.webSearchPath
  if fileExists(webSearchPath):
    discard startProcess("/usr/bin/setsid", args = [webSearchPath],
                         options = {poUsePath, poDaemon})
  else:
    echo "❌ Web search script not found: " & webSearchPath
