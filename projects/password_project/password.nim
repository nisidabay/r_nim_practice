import std/[os, strutils, posix, sysrand, terminal, parseopt, osproc]

type
  Complexity = enum
    cmpWeak, cmpMedium, cmpStrong, cmpVeryStrong

# Return a string based on Complexity
proc getCharset(level: Complexity): string =
  case level
  of cmpWeak: return "abcdefghijklmnopqrstuvwxyz0123456789"
  of cmpMedium: return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  of cmpStrong: return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
  of cmpVeryStrong: return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{};':\",./<>?`~|\\"

# Generate random password based on Complexity range with urandom
proc generatePassword(len: int, level: Complexity): string =
  let pool = getCharset(level)
  result = newStringOfCap(len)

  let randomBytes = urandom(len)
  for b in randomBytes:
    let index = b.int mod pool.len
    result.add(pool[index])

# Save the password
proc saveSecret(name, content: string) =
  let dir = getHomeDir() / "Documents" / "Passwords"

  if not dirExists(dir):
    createDir(dir)
    discard chmod(dir.cstring, Mode(0o700))

  let filePath = dir / (name & ".txt")

  try:
    writeFile(filePath, content & "\n")
    discard chmod(filePath.cstring, Mode(0o600))
  except IOError as e:
    styledEcho fgRed, "Error: Could not write to file. ", e.msg
    quit(1)

# Read password from clipboard using system tools
proc readFromClipboard(): string =
  # Try different clipboard tools available on Linux
  let clipboardTools = @["xclip -selection clipboard -o", "xsel --clipboard --output", "wl-paste"]
  
  for tool in clipboardTools:
    let (output, exitCode) = execCmdEx(tool)
    if exitCode == 0 and output.len > 0:
      return output.strip()
  
  styledEcho fgRed, "Error: Could not read from clipboard."
  styledEcho fgYellow, "Please install xclip, xsel, or wl-clipboard for clipboard support."
  quit(1)

# Read password manually from terminal (hidden input)
proc readManually(): string =
  styledEcho fgCyan, "Enter password (input hidden): "
  result = readPasswordFromStdin()
  
  if result.len == 0:
    styledEcho fgRed, "Error: Password cannot be empty."
    quit(1)

# Prompt user for manual input method
proc promptManualInput(): string =
  styledEcho styleBright, fgCyan, "\nManual Password Entry"
  styledEcho fgYellow, "Choose input method:"
  echo "  1. Type password manually"
  echo "  2. Paste from clipboard"
  styledEcho fgGreen, "  Enter choice (1 or 2): "
  
  var choice: string
  while true:
    stdout.write("  > ")
    choice = stdin.readLine().strip()
    if choice == "1" or choice == "2":
      break
    styledEcho fgRed, "Invalid choice. Please enter 1 or 2."
  
  case choice
  of "1":
    return readManually()
  of "2":
    let clipContent = readFromClipboard()
    if clipContent.len == 0:
      styledEcho fgRed, "Error: Clipboard is empty."
      quit(1)
    styledEcho fgGreen, "✔ Password read from clipboard."
    return clipContent
  else:
    quit(1)

# Help menu
proc showHelp() =
  styledEcho styleBright, fgCyan, "NimPass Generator"
  echo "A secure, local-first password tool."
  echo "\nUsage:"
  styledEcho fgYellow, "  password [options] <name>"
  echo "\nArguments:"
  echo "  <name>              The service name (e.g., github)"
  echo "\nOptions:"
  echo "  -h, --help          Show this menu"
  echo "  -l, --length:N      Set length (Default: 20)"
  echo "  -c, --complexity:C  Set complexity: weak, medium, strong, very_strong"
  echo "  -m, --manual        Enter password manually (type or paste from clipboard)"
  echo "\nNotes:"
  echo "  When using -m/--manual, the password is entered manually instead of"
  echo "  being generated. This overrides -l and -c options."
  echo "  Clipboard support requires: xclip, xsel, or wl-clipboard."
  echo "\nExample:"
  styledEcho fgGreen, "  password -l:32 -c:very_strong personal_email"
  styledEcho fgGreen, "  password -m github"
  quit(0)

# Main entry point
proc main() =
  var
    length = 20
    level = cmpStrong
    entryName = ""
    manualMode = false
    p = initOptParser()

  # Argument Parsing
  for kind, key, val in p.getopt():
    case kind
    of cmdLongOption, cmdShortOption:
      case key.toLowerAscii()
      of "h", "help": showHelp()
      of "l", "length":
        try:
          length = parseInt(val)
        except ValueError:
          styledEcho fgRed, "Error: Length must be an integer."
          quit(1)
      of "c", "complexity":
        case val.toLowerAscii()
        of "weak": level = cmpWeak
        of "medium": level = cmpMedium
        of "strong": level = cmpStrong
        of "very_strong": level = cmpVeryStrong
        else:
          styledEcho fgRed, "Error: Invalid complexity level."
          quit(1)
      of "m", "manual":
        manualMode = true
    of cmdArgument:
      entryName = key
    of cmdEnd: discard

  if entryName == "":
    styledEcho fgRed, "Error: Missing password name."
    showHelp()

  let secret = if manualMode:
    promptManualInput()
  else:
    generatePassword(length, level)

  saveSecret(entryName, secret)

  if manualMode:
    styledEcho fgGreen, "✔ Saved ", fgCyan, "manual", fgGreen,
        " password for '", entryName, "'"
  else:
    styledEcho fgGreen, "✔ Generated ", fgCyan, $level, fgGreen,
        " password for '", entryName, "'"

when isMainModule:
  main()