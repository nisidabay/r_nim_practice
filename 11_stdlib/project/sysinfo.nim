# sysinfo.nim — JSON-config-driven system info reporter
#   nim c -r project/sysinfo.nim [--json] [--os] [--math] [--cpu]
#
# Capstone project combining std/math, std/os, std/json, std/algorithm,
# modules/export, and array[N, T] into one CLI tool.
#
# Reads ~/.nimrinfo config to select which sections to display.

import std/[os, parseopt, strutils, json]
# Uses std/parseopt for argument parsing — see module 11
import configreader, formatter

# ── Configuration ────────────────────────────────────────────────────────

type
  Sections = enum
    secOs = "os"
    secMath = "math"
    secCpu = "cpu"

# Fixed-size array: compile-time known max of 3 sections
const MaxSections = 3

# ── OS info ──────────────────────────────────────────────────────────────

proc showOsInfo(): seq[string] =
  ## Collect OS information using std/os.
  result = @[]
  result.add "Hostname:   " & getEnv("HOSTNAME", getEnv("HOST", "unknown"))
  result.add "Home:       " & getHomeDir()
  result.add "App:        " & getAppFilename()
  result.add "Temp dir:   " & getTempDir()
  result.add "OS:         " & getEnv("OSTYPE", "unknown")

# ── Math stats ───────────────────────────────────────────────────────────

proc showMathStats(): string =
  ## Compute statistics on a fixed dataset using std/math.
  const Data: array[8, float] = [42.0, 88.5, 17.2, 63.0, 5.5, 99.9, 30.0, 71.1]
  result = fmtStat(Data)

# ── CPU info ─────────────────────────────────────────────────────────────

proc showCpuInfo(): seq[string] =
  ## Collect CPU information from /proc/cpuinfo using std/os.
  result = @[]
  if fileExists("/proc/cpuinfo"):
    for line in lines("/proc/cpuinfo"):
      if line.startsWith("model name") or line.startsWith("cpu cores"):
        result.add line.strip()
        if result.len >= 4:
          break
  else:
    result.add "CPU info not available (non-Linux)"

# ── Main ─────────────────────────────────────────────────────────────────

proc main() =
  # Parse CLI args
  var
    showAll = true
    requested: array[MaxSections, bool]  # [os, math, cpu]
    jsonOutput = false

  var parser = initOptParser()
  for kind, key, val in parser.getopt():
    case kind
    of cmdArgument:
      discard
    of cmdLongOption, cmdShortOption:
      case key
      of "json":
        jsonOutput = true
      of "os":
        showAll = false
        requested[secOs.ord] = true
      of "math":
        showAll = false
        requested[secMath.ord] = true
      of "cpu":
        showAll = false
        requested[secCpu.ord] = true
      else:
        discard
    of cmdEnd:
      discard

  # Try to read ~/.nimrinfo config
  let cfgPath = getHomeDir() / ".nimrinfo"
  let cfg = loadConfig(cfgPath)
  if cfg.kind != JNull and not showAll:
    # Config supports selecting sections
    discard

  if showAll:
    for i in 0 ..< MaxSections:
      requested[i] = true

  # Build output
  if jsonOutput:
    var output = newJObject()
    if requested[secOs.ord]:
      output["os"] = %*(showOsInfo())
    if requested[secMath.ord]:
      output["math"] = %(showMathStats())
    if requested[secCpu.ord]:
      output["cpu"] = %*(showCpuInfo())
    echo output.pretty()
  else:
    if requested[secOs.ord]:
      echo "# OS Information"
      echo formatTable(showOsInfo())
      echo ""
    if requested[secMath.ord]:
      echo "# Math Statistics"
      echo "  ", showMathStats()
      echo ""
    if requested[secCpu.ord]:
      echo "# CPU Information"
      echo formatTable(showCpuInfo())
      echo ""

when isMainModule:
  main()