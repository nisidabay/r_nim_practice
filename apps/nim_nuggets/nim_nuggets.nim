# Nim
#
# nim_nuggets refresher utility to learn Nim
import std/strutils
import std/strformat
import std/random
import std/times
import std/terminal
import std/os
import std/osproc

# --- Configuration ---
const Separator = "•••"
const AppDirName = "nim_nuggets"
const DefaultLinkName = "default_nugget.txt"
const Editor = getEnv("EDITOR", "nvim")

# --- Types ---
type
  SearchResult = object
    topic: string
    snippet: string
    preview: string

# --- Visuals (Simulating Rich Library) ---

proc longestLineLength(text: string): int =
  var maxLen = 0
  for line in text.splitLines():
    if line.len > maxLen:
      maxLen = line.len
  result = maxLen

proc printPanel(text: string, title: string = "",
    color: ForegroundColor = fgYellow, borderColor: ForegroundColor = fgBlue) =
  let contentMaxLen = longestLineLength(text)
  let titleWidth = if title.len > 0: title.len + 2 else: 0       # " title "

  # Panel inner width should fit content or title, whichever is longer
  # Add 2 for left/right padding (1 space on each side)
  let innerWidth = max(contentMaxLen + 2, titleWidth + 2)

  let lines = text.splitLines()

  # Top Border
  stdout.setForegroundColor(borderColor, true)
  stdout.write("╭")
  if title.len > 0:
    stdout.write(" ", title, " ")
    stdout.write(repeat("─", innerWidth - titleWidth))
  else:
    stdout.write(repeat("─", innerWidth))
  stdout.write("╮\n")

  # Body - print each line with proper padding and borders
  for line in lines:
    stdout.setForegroundColor(borderColor, true)
    stdout.write("│")
    stdout.resetAttributes()
    stdout.setForegroundColor(color, true)

    # Print line with padding to match panel width
    stdout.write(" ", line)
    let rightPadding = innerWidth - line.len - 1 # -1 for the left space we just added
    stdout.write(repeat(" ", rightPadding))

    stdout.resetAttributes()
    stdout.setForegroundColor(borderColor, true)
    stdout.write("│\n")

  # Bottom border
  stdout.setForegroundColor(borderColor, true)
  stdout.write("╰")
  stdout.write(repeat("─", innerWidth))
  stdout.write("╯\n")
  stdout.resetAttributes()

proc printError(msg: string) =
  printPanel(fmt"💣{msg}", "Error", fgRed, fgRed)

proc printSuccess(msg: string) =
  printPanel(fmt"👍{msg}", "Success", fgGreen, fgBlue)

# --- System Helpers ---

proc getNuggetsDir(): string =
  result = joinPath(getHomeDir(), "bin", AppDirName)
  if not dirExists(result):
    createDir(result)

proc getDefaultLinkPath(): string =
  joinPath(getNuggetsDir(), DefaultLinkName)

proc getActiveNuggetPath(): string =
  let link = getDefaultLinkPath()
  # check if symlink or regular file exists
  if symlinkExists(link) or fileExists(link):
    try:
      return expandSymlink(link)
    except OSError:
      # If it's a regular file (not symlink), return it directly
      return link
  return ""

proc setActiveNugget(targetPath: string) =
  let link = getDefaultLinkPath()
  if symlinkExists(link) or fileExists(link):
    removeFile(link)

  createSymlink(targetPath, link)
  printSuccess(fmt"Switched topic to: {extractFilename(targetPath)}")

# --- FZF Integration ---

proc runFzf(options: seq[string], prompt: string): string =
  if options.len == 0:
    return ""

  # Write options to a temporary file
  let tempInput = getTempDir() / fmt"fzf_input_{getTime().toUnix}.txt"
  let tempOutput = getTempDir() / fmt"fzf_output_{getTime().toUnix}.txt"

  try:
    writeFile(tempInput, options.join("\n"))

    # Build fzf command - using shell redirection for proper terminal interaction
    let cmd = fmt"fzf --prompt {quoteShell(prompt)} --height 40% --layout reverse --border < {quoteShell(tempInput)} > {quoteShell(tempOutput)}"

    let exitCode = execCmd(cmd)

    # Read result if successful
    if exitCode == 0 and fileExists(tempOutput):
      result = readFile(tempOutput).strip()
    else:
      result = ""

  finally:
    # Cleanup temp files
    if fileExists(tempInput):
      removeFile(tempInput)
    if fileExists(tempOutput):
      removeFile(tempOutput)

# --- Core Logic ---

proc getAllTopics(): seq[string] =
  let directory = getNuggetsDir()
  for kind, path in walkDir(directory):
    if kind == pcFile and path.endsWith(".txt") and extractFilename(path) != DefaultLinkName:
      result.add(extractFilename(path))
  result

proc loadSnippets(path: string): seq[string] =
  if not fileExists(path): return @[]
  let content = readFile(path)

  # Split by "•••"
  for raw in content.split(Separator):
    let cleaned = raw.strip()
    if cleaned.len > 0:
      result.add(cleaned)

# --- Search Helper Functions ---

proc getSearchQuery(searchTerm: string): string =
  ## Gets search query from parameter or prompts user
  if searchTerm.len > 0:
    return searchTerm

  stdout.write("Enter search term: ")
  result = stdin.readLine().strip()

proc createSnippetPreview(snippet: string, maxLen: int = 60): string =
  ## Creates a truncated preview of a snippet
  let lines = snippet.splitLines()
  let firstLine = if lines.len > 0: lines[0] else: snippet

  if firstLine.len > maxLen:
    result = firstLine[0..maxLen-1] & "..."
  else:
    result = firstLine

proc searchAllTopics(query: string): seq[SearchResult] =
  ## Searches all topics for snippets containing the query (case-insensitive)
  let topics = getAllTopics()

  for topicFile in topics:
    let topicPath = joinPath(getNuggetsDir(), topicFile)
    let snippets = loadSnippets(topicPath)
    let topicName = topicFile.replace(".txt", "")

    for snippet in snippets:
      if snippet.toLower().contains(query.toLower()):
        result.add(SearchResult(
          topic: topicName,
          snippet: snippet,
          preview: createSnippetPreview(snippet)
        ))

proc formatSearchResultsForFzf(results: seq[SearchResult]): seq[string] =
  ## Formats search results for fzf display
  for i, res in pairs(results):
    result.add(fmt"{i} | [{res.topic}] {res.preview}")

proc parseSearchSelection(selection: string): int =
  ## Extracts the result index from fzf selection
  let parts = selection.split(" | ")
  if parts.len > 0:
    try:
      return parseInt(parts[0])
    except ValueError:
      return -1
  return -1

proc openTopicInEditor(topicName: string) =
  ## Opens a topic file in the configured editor
  let nuggetPath = joinPath(getNuggetsDir(), topicName & ".txt")
  let exitCode = execCmd(fmt"{Editor} {quoteShell(nuggetPath)}")

  if exitCode == 0:
    printSuccess(fmt"Nugget ({nuggetPath}) edited.")

proc handleSearchResults(results: seq[SearchResult], query: string) =
  ## Displays search results in fzf and handles selection
  let options = formatSearchResultsForFzf(results)
  let selection = runFzf(options, fmt"Search: '{query}'")

  if selection.len == 0:
    return

  let id = parseSearchSelection(selection)

  if id >= 0 and id < results.len:
    printPanel(results[id].snippet, fmt"Found in: {results[id].topic}")
    openTopicInEditor(results[id].topic)
  else:
    printError("Invalid selection")

# --- Actions ---

proc changeTopic() =
  let topics = getAllTopics()
  if topics.len == 0:
    printError("No topics found.")
    return

  let selection = runFzf(topics, "Select Topic")
  if selection.len > 0:
    let fullPath = joinPath(getNuggetsDir(), selection)
    setActiveNugget(fullPath)

proc editNugget() =
  let current = getActiveNuggetPath()
  if current.len == 0:
    printError("No active topic selected. Use -c first.")
    return

  let exitCode = execCmd(fmt"nvim {quoteShell(current)}")
  if exitCode == 0:
    printSuccess("Nugget edited.")

proc newNugget() =
  stdout.write("Enter new topic name (no extension): ")
  let name = stdin.readLine().strip()
  if name.len == 0: return

  let filename = name & ".txt"
  let path = joinPath(getNuggetsDir(), filename)

  if fileExists(path):
    printError("Topic already exists.")
  else:
    # Initialize with the separator
    writeFile(path, fmt"{Separator} Initial Snippet")
    printSuccess(fmt"Created {filename}")
    setActiveNugget(path)

proc randomSnippet() =
  let current = getActiveNuggetPath()
  if current.len == 0:
    printError("No active topic. Run with -c to select one.")
    return

  let snippets = loadSnippets(current)
  if snippets.len == 0:
    printError("Topic is empty.")
    return

  randomize()
  let snippet = sample(snippets)
  let topicName = current.extractFilename().replace(".txt", "")

  printPanel(snippet, fmt"Nugget: {topicName}")

proc listSnippets() =
  let current = getActiveNuggetPath()
  if current.len == 0:
    printError("No active topic.")
    return

  let snippets = loadSnippets(current)
  var options: seq[string] = @[]

  for i, s in pairs(snippets):
    # Get the first line of the snippet to use as the title in FZF
    let lines = s.splitLines()
    let firstLine = if lines.len > 0: lines[0] else: "Empty"

    # Clean up the line for display (truncate if too long)
    let maxLen = if firstLine.len > 0: min(firstLine.len - 1, 70) else: 0
    let displayLine = if firstLine.len > 0:
                        firstLine[0 .. maxLen].replace("\n", " ")
                      else:
                        "Empty"
    options.add(fmt"{i} - {displayLine}")

  let selection = runFzf(options, "Browse Snippets")
  if selection.len > 0:
    let parts = selection.split(" - ")
    if parts.len > 0:
      try:
        let id = parseInt(parts[0])
        if id >= 0 and id < snippets.len:
          printPanel(snippets[id], "Selected Snippet")
      except ValueError:
        printError("Invalid selection")

proc searchNuggets(searchTerm: string = "") =
  ## Search for snippets across all topics
  let query = getSearchQuery(searchTerm)

  if query.len == 0:
    printError("No search term provided.")
    return

  let topics = getAllTopics()
  if topics.len == 0:
    printError("No topics found.")
    return

  let results = searchAllTopics(query)

  if results.len == 0:
    printError(fmt"No snippets found containing '{query}'")
    return

  handleSearchResults(results, query)

proc mergeNuggets() =
  let directory = getNuggetsDir()
  let outFile = joinPath(directory, "ALL_NUGGETS.txt")
  var allContent = ""

  for topic in getAllTopics():
    allContent.add(fmt"--- {topic} ---" & "\n")
    allContent.add(readFile(joinPath(directory, topic)))
    allContent.add("\n\n")

  writeFile(outFile, allContent)
  printSuccess("Merged all nuggets to ALL_NUGGETS.txt")

proc checkWeekly() =
  let link = getDefaultLinkPath()
  if not symlinkExists(link) and not fileExists(link): return

  try:
    let info = getFileInfo(link)
    let currentTime = getTime()
    let diff = currentTime - info.lastWriteTime

    if inDays(diff) > 7:
      printPanel("It's been over a week since you changed topics. Time to rotate!",
          "Weekly Reminder", fgRed)
  except OSError:
    discard

# --- Main ---

proc showHelp() =
  echo """
  Python Nuggets Univ (Nim Port)
  
  -c          Change Topic (fzf)
  -e          Edit current topic (nvim)
  -l          List/Browse snippets in current topic (fzf)
  -n          New Topic
  -m          Merge all topics
  -s [term]   Search for term across all nuggets
  -R          Random Snippet (Default)
  """

proc main() =
  let params = commandLineParams()
  checkWeekly()

  if params.len == 0:
    randomSnippet()
    return

  case params[0]:
    of "-c": changeTopic()
    of "-e": editNugget()
    of "-n": newNugget()
    of "-l": listSnippets()
    of "-m": mergeNuggets()
    of "-s":
      if params.len > 1:
        # Search term provided as argument
        searchNuggets(params[1])
      else:
        # Prompt for search term
        searchNuggets()
    of "-R": randomSnippet()
    of "-h", "--help": showHelp()
    else: randomSnippet()

when isMainModule:
  main()
