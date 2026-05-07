# Extract keymappings or layouts from dwm
import std/[strutils, strformat, os, parseopt]

# --- CONFIGURATION ---
# Change this to point to your actual config.h
const ConfigPath = expandTilde("~/suckless/dwm-luke/config.h")

# --- CLEANUP HELPERS ---
func cleanKey(k: string): string =
  result = k.replace("XK_", "").replace("Mod4Mask", "Super")
  result = result.replace("ControlMask", "Ctrl").replace("ShiftMask", "Shift")
  result = result.replace("|", "+").strip()

func cleanCmd(cmd: string): string =
  # Turns "SHCMD("sh -c '~/bin/notes.sh'")" into "notes.sh"
  result = cmd.replace("SHCMD", "").replace("spawn", "").replace("TERMCMD", "")
  result = result.replace("\"", "").replace("(", "").replace(")", "")
  result = result.replace("/bin/sh", "").replace("-c", "").replace("'", "")
  # Extract just the filename if it's a script path
  if "/" in result:
    result = result.split("/")[^1]
  result = result.strip()

# --- PARSING LOGIC ---
proc parseConfig(mode: string) =
  if not fileExists(ConfigPath):
    echo fmt"Error: Config not found at {ConfigPath}"
    quit(1)

  let lines = readFile(ConfigPath).splitLines()
  var inKeys = false
  var inLayouts = false
  var lastComment = ""

  for line in lines:
    let clean = line.strip()

    # 1. DETECT SECTIONS
    if "static const Key keys[]" in clean: inKeys = true; continue
    if "static const Layout layouts[]" in clean: inLayouts = true; continue
    if clean == "};":
      inKeys = false
      inLayouts = false
      continue

    # 2. PARSE KEYS
    if inKeys and mode == "keys":
      # Capture comments strictly appearing BEFORE the key
      if clean.startsWith("/*") and clean.endsWith("*/"):
        lastComment = clean.replace("/*", "").replace("*/", "").strip()
        continue

      # Handle Tag Macros (Special Case)
      if "TAGKEYS" in clean:
        let parts = clean.split("TAGKEYS")
        for p in parts:
          if "XK_" in p:
            let k = p.split(",")[0].replace("(", "").replace("XK_", "").strip()
            echo fmt"Tag {k} Operations               (Super + [Shift/Ctrl] + {k})"
        continue

      # Handle Standard Keys
      if clean.startsWith("{") and "," in clean:
        let parts = clean.replace("{", "").replace("}", "").split(",")
        if parts.len >= 3:
          let mods = cleanKey(parts[0])
          let key = cleanKey(parts[1])
          let funcName = parts[2].strip()
          let arg = if parts.len > 3: parts[3].strip() else: ""

          var desc = ""

          # Priority 1: The comment we found earlier
          if lastComment.len > 0:
            desc = lastComment
            lastComment = ""
          # Priority 2: Inferred from command
          else:
            if "spawn" in funcName or "SHCMD" in arg:
              desc = cleanCmd(arg)
            elif "setlayout" in funcName:
              desc = "Set Layout: " & arg.replace("&layouts", "").replace("[",
                  "").replace("]", "")
            else:
              desc = fmt"{funcName} {cleanCmd(arg)}"

          # Formatting for dmenu (Align description left, keys right)
          # We use a distinct separator that dmenu can filter later if needed
          if desc.len > 0:
            echo fmt"{desc:<35} ({mods} + {key})"

    # 3. PARSE LAYOUTS
    if inLayouts and mode == "layouts":
      # Your layouts look like: {"[]=", tile}, /* Comment */
      if clean.startsWith("{") and "/*" in clean:
        let symbolStart = clean.find("\"") + 1
        let symbolEnd = clean.find("\"", symbolStart)
        let symbol = clean[symbolStart ..< symbolEnd]

        let commentStart = clean.find("/*") + 2
        let commentEnd = clean.find("*/")
        let desc = clean[commentStart ..< commentEnd].strip()

        # Output: "Description [Symbol]"
        echo fmt"{desc:<30} [{symbol}]"

# --- MAIN ENTRY ---
var p = initOptParser()
var mode = "keys" # Default mode

for kind, key, val in p.getopt():
  if kind == cmdLongOption and key == "layouts":
    mode = "layouts"

parseConfig(mode)
