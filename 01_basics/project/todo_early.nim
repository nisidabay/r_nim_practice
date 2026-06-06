# Nim
#
# Todo script
import strutils, json, os, strformat, osproc

# --- Todo Item Type ---
type
  Todo = ref object
    task: string
    completed: bool
    priority: string # Optional: "high", "medium", "low"
    category: string # Optional: "work", "personal", "shopping", etc.
    time: string
    sound: bool

# --- Global Todo List ---
var todos: seq[Todo] = @[]
let scriptDir = getHomeDir() / "bin" / "nim_todos"
let TODO_FILE = scriptDir / "todos.json"
let SOUND_FILE = scriptDir / "bell.mp3"

## checkScriptDir - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc checkScriptDir() =
  if not dirExists(scriptDir):
    try:
      createDir(scriptDir)
    except Exception as e:
      echo &"Error: {e.msg}"

## loadTodos - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc loadTodos() =
  checkScriptDir()
  if fileExists(TODO_FILE):
    try:
      let data = readFile(TODO_FILE)
      todos = parseJson(data).to(seq[Todo])
    except Exception as e:
      echo &"Error loading todos: {e.msg}"

## saveTodos - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc saveTodos() =
  try:
    let data = %*(todos)
    writeFile(TODO_FILE, data.pretty)
  except Exception as e:
    echo &"Error saving todos: {e.msg}"

# --- Helper: Display Todos ---
## displayTodos - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc displayTodos() =
  if todos.len == 0:
    echo "No todos yet! ✨"
    return

  echo "\n--- Todos ---"
  for i, todo in todos:
    let status = if todo.completed: "[X]" else: "[ ]"
    let priorityStr = if todo.priority != "": &" [{todo.priority}]" else: ""
    let categoryStr = if todo.category != "": &" ({todo.category})" else: ""
    let timeStr = if todo.time != "": &" 🕐{todo.time}" else: ""
    let soundStr = if todo.sound: " 🔊" else: ""
    echo &"{i + 1}. {status} {todo.task}{priorityStr}{categoryStr}{timeStr}{soundStr}"
  echo "---------------"

## addTodo - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc addTodo(task: string) =
  if task.strip().len == 0:
    echo "Cannot add an empty task."
    return

  todos.add(Todo(task: task, completed: false, priority: "", category: "",
      time: "", sound: false))
  echo &"Added: '{task}'"
  saveTodos()
  displayTodos()

## listTodos - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc listTodos() =
  displayTodos()

# --- Helper: Get Index from Arg ---
## parseIndex - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc parseIndex(arg: string): int =
  if arg.strip().len == 0:
    echo "Error: No todo number provided."
    return -1

  try:
    let index = parseInt(arg) - 1
    if index >= 0 and index < todos.len:
      return index
    else:
      echo &"Error: No todo found with number {arg}."
      return -1
  except ValueError:
    echo &"Error: '{arg}' is not a valid number."
    return -1

# --- Command: Complete / Done ---
## completeTodo - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc completeTodo(index: int) =
  if index < 0: return

  if todos[index].completed:
    echo "Task already marked as complete."
  else:
    todos[index].completed = true
    echo &"Completed: '{todos[index].task}'"
    saveTodos()

  displayTodos()

## removeTodo - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc removeTodo(index: int) =
  if index < 0: return

  let removedTask = todos[index].task
  todos.del(index)
  echo &"Removed: '{removedTask}'"
  saveTodos()
  displayTodos()

# --- Command: Edit Task ---
## editTodo - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc editTodo(index: int, newTask: string) =
  if index < 0: return

  if newTask.strip().len == 0:
    echo "Cannot edit task with empty content."
    return

  let oldTask = todos[index].task
  todos[index].task = newTask
  echo &"Edited: '{oldTask}' -> '{newTask}'"
  saveTodos()
  displayTodos()

# --- Command: Set Notification ---
## scheduleTodo - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc scheduleTodo(index: int, timeStr: string, sound: bool): bool =
  # Validate index
  if index < 0 or index >= todos.len:
    echo "❌ Invalid todo index"
    return false

  let todoItem = todos[index].task
  let atCmd = "/usr/bin/at"
  let player = "/usr/bin/mpv"
  let musicFile = SOUND_FILE

  # Verify files exist
  if sound and not fileExists(musicFile):
    echo "❌ Warning: Sound file not found: ", musicFile
    echo "👉 Place 'bell.mp3' in ", scriptDir
    # Continue without sound instead of failing
    return false

  if not fileExists(player):
    echo "❌ mpv not found at ", player
    echo "👉 Install with: sudo pacman -S mpv"
    return false

  # Get environment variables
  let display = getEnv("DISPLAY", ":0")
  let dbusAddress = getEnv("DBUS_SESSION_BUS_ADDRESS", "")
  let pulseServer = getEnv("PULSE_SERVER", "")

  # Build command parts
  var parts: seq[string] = @[
    "export DISPLAY=" & quoteShell(display)
  ]

  if dbusAddress != "":
    parts.add("export DBUS_SESSION_BUS_ADDRESS=" & quoteShell(dbusAddress))
  if pulseServer != "":
    parts.add("export PULSE_SERVER=" & quoteShell(pulseServer))

  # Add notification
  parts.add("notify-send -i dialog-information 'Todo Reminder' '" &
            todoItem.replace("'", "'\\''") & "'")

  # Add sound if requested
  if sound and fileExists(musicFile):
    parts.add(player & " --no-video --volume=70 --quiet " & quoteShell(musicFile))

  # Join all commands with && so they run sequentially
  let fullCmd = parts.join(" && ")
  let cmd = "echo " & quoteShell(fullCmd) & " | " & atCmd & " " & quoteShell(timeStr)

  echo "Executing: ", cmd
  let result = execCmdEx(cmd, options = {poStdErrToStdOut})

  if result.exitCode == 0:
    # Save the schedule info to the todo
    todos[index].time = timeStr
    todos[index].sound = sound
    saveTodos()

    echo "✅ Successfully scheduled: ", todoItem
    if sound: echo "🔊 With sound: ", extractFilename(musicFile)
    echo "🕐 For time: ", timeStr
    echo "📝 at job details:"
    echo result.output.strip()
    return true
  else:
    echo "❌ Failed to schedule todo: ", todoItem
    echo "Error output: ", result.output.strip()
    return false

# --- Command: Set Priority ---
## setPriority - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc setPriority(index: int, priority: string) =
  if index < 0: return

  let validPriorities = ["high", "medium", "low"]
  if priority notin validPriorities:
    echo &"Error: Priority must be one of: {validPriorities.join(\", \")}"
    return

  todos[index].priority = priority
  echo &"Set priority '{priority}' for task: '{todos[index].task}'"
  saveTodos()
  displayTodos()

# --- Command: Set Category ---
## setCategory - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc setCategory(index: int, category: string) =
  if index < 0: return

  if category.strip().len == 0:
    echo "Cannot set empty category."
    return

  todos[index].category = category
  echo &"Set category '{category}' for task: '{todos[index].task}'"
  saveTodos()
  displayTodos()

# --- Command: Help ---
## showHelp - description placeholder
## Params: (add parameters description)
## Returns: (add return description)
proc showHelp() =
  echo """
USAGE: todo [command] [args]  (no command = list)

COMMANDS:
  add <task>                 done|complete <num>
  list                       rm|remove|del <num>
  edit <num> <task>          priority <num> high|medium|low
  category <num> <cat>       schedule <num> <time>
  sound <num> <time>         help

EXAMPLES:
  todo add "Buy groceries"           # Add task
  todo priority 1 high               # Set priority
  todo sound 1 "tomorrow 9:00"       # Schedule with sound
  todo done 1                        # Mark complete
"""

# --- Main Program Logic ---
loadTodos()

if paramCount() == 0:
  listTodos()
else:
  let command = paramStr(1).toLower()

  case command
  of "add":
    if paramCount() < 2:
      echo "Error: 'add' command needs a task."
      showHelp()
    else:
      var task = ""
      for i in 2 .. paramCount():
        task.add(paramStr(i) & " ")
      addTodo(task.strip())

  of "list":
    listTodos()

  of "done", "complete":
    if paramCount() < 2:
      echo "Error: 'done' command needs a todo number."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        completeTodo(index)

  of "rm", "remove", "del", "delete":
    if paramCount() < 2:
      echo "Error: 'rm' command needs a todo number."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        removeTodo(index)

  of "edit":
    if paramCount() < 3:
      echo "Error: 'edit' command needs a todo number and new task."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        var newTask = ""
        for i in 3 .. paramCount():
          newTask.add(paramStr(i) & " ")
        editTodo(index, newTask.strip())

  of "schedule":
    if paramCount() < 3:
      echo "Error: 'schedule' command needs a todo number and time."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        var timeStr = ""
        for i in 3 .. paramCount():
          timeStr.add(paramStr(i) & " ")
        let success = scheduleTodo(index, timeStr.strip(), false)
        if not success:
          echo "Failed to schedule task."

  of "sound":
    if paramCount() < 3:
      echo "Error: 'sound' command needs a todo number and time."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        var timeStr = ""
        for i in 3 .. paramCount():
          timeStr.add(paramStr(i) & " ")
        let success = scheduleTodo(index, timeStr.strip(), true)
        if not success:
          echo "Failed to schedule task."

  of "priority":
    if paramCount() < 3:
      echo "Error: 'priority' command needs a todo number and priority level."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        let priority = paramStr(3).toLower()
        setPriority(index, priority)

  of "category":
    if paramCount() < 3:
      echo "Error: 'category' command needs a todo number and category."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        var category = ""
        for i in 3 .. paramCount():
          category.add(paramStr(i) & " ")
        setCategory(index, category.strip())

  of "help", "--help", "-h":
    showHelp()

  else:
    echo &"Unknown command: '{command}'"
    showHelp()
