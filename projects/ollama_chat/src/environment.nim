## Environment detection and setup (Wayland vs X11)

import std/[os, osproc, strutils, sequtils]

type
  DisplayServer* = enum
    dsWayland
    dsX11
    dsUnknown

  Environment* = object
    displayServer*: DisplayServer
    terminal*: string
    copyCmd*: string
    isTmux*: bool

proc detectDisplayServer*(): DisplayServer =
  if getEnv("WAYLAND_DISPLAY").len > 0:
    return dsWayland
  elif getEnv("DISPLAY").len > 0:
    return dsX11
  else:
    return dsUnknown

proc checkDependency*(program: string): bool =
  execCmd("command -v " & program & " >/dev/null 2>&1") == 0

proc checkDependencies*(deps: openArray[string]): seq[string] =
  ## Returns list of missing dependencies
  result = @[]
  for dep in deps:
    if not checkDependency(dep):
      result.add(dep)

proc setupEnvironment*(): Environment =
  result.displayServer = detectDisplayServer()
  result.isTmux = getEnv("TMUX").len > 0

  case result.displayServer
  of dsWayland:
    result.terminal = "foot"
    result.copyCmd = "wl-copy"
    let missing = checkDependencies(["foot", "wl-copy", "fuzzel"])
    if missing.len > 0:
      quit("❌ Missing dependencies: " & missing.join(", "), 1)
  of dsX11:
    result.terminal = "st"
    result.copyCmd = "xsel -ib"
    let missing = checkDependencies(["st", "xsel", "dmenu"])
    if missing.len > 0:
      quit("❌ Missing dependencies: " & missing.join(", "), 1)
  of dsUnknown:
    result.terminal = "xterm"
    result.copyCmd = "xclip -selection clipboard"

proc copyToClipboard*(env: Environment, text: string) =
  let process = startProcess("/bin/sh", args = ["-c", "echo -n " & quoteShell(
      text) & " | " & env.copyCmd])
  discard process.waitForExit()
  process.close()

proc showMenu*(env: Environment, prompt: string, options: seq[string]): string =
  ## Show a menu using fuzzel (Wayland) or dmenu (X11)
  let input = options.join("\n")
  var cmd: string

  case env.displayServer
  of dsWayland:
    cmd = "echo " & quoteShell(input) & " | fuzzel --dmenu --match-mode=exact -p " &
        quoteShell(prompt)
  of dsX11:
    cmd = "echo " & quoteShell(input) & " | dmenu -c -i -l 20 -p " & quoteShell(prompt)
  of dsUnknown:
    cmd = "echo " & quoteShell(input) & " | fzf --prompt=" & quoteShell(prompt)

  let (output, exitCode) = execCmdEx(cmd)
  if exitCode == 0:
    result = output.strip()
  else:
    result = ""

proc launchTerminal*(env: Environment) =
  ## Launch a new detached terminal
  discard startProcess("/usr/bin/setsid", args = [env.terminal],
                       options = {poUsePath, poDaemon})

proc showTmuxWarning*(): string =
  if getEnv("TMUX").len > 0:
    result = "💻 \e[31mTHIS IS A TMUX SESSION\e[0m 💻\n💻 \e[31mCtrl-C to quit!\e[0m 💻"
  else:
    result = ""
