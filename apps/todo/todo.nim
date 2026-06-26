# Nim
#
# Todo application (with enums)

import strutils, json, os, strformat, osproc

# --- Todo Item Type --
type
  Priority = enum
    high, medium, low

  Category = enum
    computerLanguage, gym, personal

type
  Todo = ref object
    task: string
    completed: bool
    priority: Priority
    category: Category
    time: string
    sound: bool

# --- Global Todo List ---
const VERSION = "0.0.1"
var todos: seq[Todo] = @[]
let scriptDir = getHomeDir() / "bin" / "nim_todos"
let TODO_FILE = scriptDir / "todos.json"
let SOUND_FILE = scriptDir / "bell.mp3"

# --- Procedures ---

# Ensure the scriptDir exists
proc checkScriptDir() =
  if not dirExists(scriptDir):
    try:
      createDir(scriptDir)
    except Exception as e:
      echo &"Error: {e.msg}"

# Ensure a default TODO_FILE
proc touchTodos() =
  if not fileExists(TODO_FILE):
    try:
      writeFile(TODO_FILE, "[]")
      echo fmt"Created default 'todo.json' file at '{TODO_FILE}'"
    except IOError:
      echo fmt"Warning: Could not write default 'todo.json' to '{TODO_FILE}'"

# Load todos from file
proc loadTodos() =
  checkScriptDir()

  if fileExists(TODO_FILE):
    try:
      let data = readFile(TODO_FILE)
      if data.strip.len == 0:
        todos = @[]
        return

      let jsonData = parseJson(data)
      
      # Ensure the root of the JSON is an array
      if jsonData.kind != JArray:
        echo "Error loading todos: Expected a JSON array in " & TODO_FILE
        return

      var loadedTodos: seq[Todo] = @[]

      for node in jsonData:
        var todoItem = new(Todo)

        if node.hasKey("task"):
          todoItem.task = node["task"].str
        else:
          todoItem.task = "no task"
        
        if node.hasKey("completed"):
          todoItem.completed = node["completed"].getBool
        else:
          todoItem.completed = false
        
        if node.hasKey("time"):
          todoItem.time = node["time"].str
        else:
          todoItem.time = ""
          
        if node.hasKey("sound"):
          todoItem.sound = node["sound"].getBool
        else:
          todoItem.sound = false

        if node.hasKey("priority"):
          try:
            todoItem.priority = parseEnum[Priority](node["priority"].str.toLower())
          except ValueError:
            todoItem.priority = Priority.low
        else:
          todoItem.priority = Priority.low

        if node.hasKey("category"):
          try:
            todoItem.category = parseEnum[Category](node["category"].str)
          except ValueError:
            todoItem.category = Category.personal
        else:
          todoItem.category = Category.personal
        
        loadedTodos.add(todoItem)
        
      todos = loadedTodos
    except Exception as e:
      echo &"Error loading todos: {e.msg}"
  else:
    touchTodos()


# Save todos to TODO_FILE
proc saveTodos() =
  try:
    let data = %*(todos)
    writeFile(TODO_FILE, data.pretty)
  except Exception as e:
    echo &"Error saving todos: {e.msg}"

# Display Todos
proc displayTodos() =
  if todos.len == 0:
    echo "No todos yet! ✨"
    return

  echo "\n--- Todos ---"
  for i, todo in todos:
    let status = if todo.completed: "[X]" else: "[ ]"
    let priorityStr =
      case todo.priority
      of Priority.high: " 🔴 high"
      of Priority.medium: " 🟡 medium"
      of Priority.low: " ✅ low"

    let categoryStr =
      case todo.category
      of Category.computerLanguage: " 💻 computer language"
      of Category.gym: " 🏋️ gym"
      of Category.personal: " ❤️ personal"

    let timeStr = if todo.time != "": &" 🕐{todo.time}" else: ""
    let soundStr = if todo.sound: " 🔊" else: ""
    
    echo &"{i + 1}. {status} {todo.task}{priorityStr}{categoryStr}{timeStr}{soundStr}"
  echo "---------------"

# Add a new todo
proc addTodo(task: string) =
  if task.strip().len == 0:
    echo "Cannot add an empty task."
    return

  todos.add(Todo(
    task: task,
    completed: false,
    priority: Priority.low,  # default priority
    category: Category.personal,  # default category
    time: "",
    sound: false
  ))
  echo &"Added: '{task}'"
  saveTodos()
  displayTodos()

# List all todos
proc listTodos() =
  displayTodos()

# Parse index from argument (1-indexed)
proc parseIndex(arg: string): int =
  if arg.strip.len == 0:
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

# Complete a todo
proc completeTodo(index: int) =
  if index < 0: return

  if todos[index].completed:
    echo "Task already marked as complete."
  else:
    todos[index].completed = true
    echo &"Completed: '{todos[index].task}'"
    saveTodos()

  displayTodos()

# Remove a todo
proc removeTodo(index: int) =
  if index < 0: return

  let removedTask = todos[index].task
  todos.del(index)
  echo &"Removed: '{removedTask}'"
  saveTodos()
  displayTodos()

# Edit task
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

# Schedule todo with time and sound (uses at + mpv)
proc scheduleTodo(index: int, timeStr: string, sound: bool): bool =
  if index < 0 or index >= todos.len:
    echo "❌ Invalid todo index"
    return false

  let atCmd = findExe("at")
  if atCmd.len == 0:
    echo "❌ Error: 'at' executable not found in PATH."
    return false

  var player = ""
  if sound:
    player = findExe("mpv")
    if player.len == 0:
      echo "❌ Warning: 'mpv' not found. Cannot play sound."
      return false

  let todoItem = todos[index].task
  let musicFile = SOUND_FILE

  # Verify files exist
  if sound and not fileExists(musicFile):
    echo "❌ Warning: Sound file not found: ", musicFile
    echo "👉 Place 'bell.mp3' in ", scriptDir
    return false

  # Environment variables
  let display = getEnv("DISPLAY", ":0")
  let dbusAddress = getEnv("DBUS_SESSION_BUS_ADDRESS", "")
  let pulseServer = getEnv("PULSE_SERVER", "")

  var parts: seq[string] = @[
    "export DISPLAY=" & quoteShell(display)
  ]

  if dbusAddress != "":
    parts.add("export DBUS_SESSION_BUS_ADDRESS=" & quoteShell(dbusAddress))
  if pulseServer != "":
    parts.add("export PULSE_SERVER=" & quoteShell(pulseServer))

  # Add notification
  parts.add("notify-send -i dialog-information 'Todo Reminder' '" &
            todoItem.replace("'", "'\\''") & "' ")

  # Add sound if requested
  if sound and fileExists(musicFile):
    parts.add(player & " --no-video --volume=70 --quiet " & quoteShell(musicFile))

  let fullCmd = parts.join(" && ")
  let cmd = "echo " & quoteShell(fullCmd) & " | " & atCmd & " " & quoteShell(timeStr)

  echo "Executing: ", cmd
  let result = execCmdEx(cmd, options = {poStdErrToStdOut})

  if result.exitCode == 0:
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

# Set priority (uses enum)
proc setPriority(index: int, priority: Priority) =
  if index < 0: return

  todos[index].priority = priority
  echo &"Set priority '{priority}' for task: '{todos[index].task}'"
  saveTodos()
  displayTodos()

# Set category (uses enum)
proc setCategory(index: int, category: Category) =
  if index < 0: return

  todos[index].category = category
  echo &"Set category '{category}' for task: '{todos[index].task}'"
  saveTodos()
  displayTodos()

# Show help message
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
  todo priority 1 high               # Set priority (high)
  todo sound 1 "tomorrow 9:00"      # Schedule with sound
  todo done 1                       # Mark complete
  todo category 2 gym               # Set to gym
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
        let priorityStr = paramStr(3).toLower()
        case priorityStr
          of "high": setPriority(index, Priority.high)
          of "medium": setPriority(index, Priority.medium)
          of "low": setPriority(index, Priority.low)
          else:
            echo &"Error: Priority must be one of: high, medium, low"

  of "category":
    if paramCount() < 3:
      echo "Error: 'category' command needs a todo number and category."
      showHelp()
    else:
      let index = parseIndex(paramStr(2))
      if index != -1:
        var categoryStr = ""
        for i in 3 .. paramCount():
          categoryStr.add(paramStr(i) & " ")
        categoryStr = categoryStr.strip()

        # Map string input to enum
        case categoryStr.toLower()
        of "computerlanguage", "computer language": setCategory(index, Category.computerLanguage)
        of "gym", "fitness": setCategory(index, Category.gym)
        of "personal", "personal life": setCategory(index, Category.personal)
        else:
          echo &"Error: Category must be one of: computerLanguage, gym, personal"

  of "help", "--help", "-h":
    showHelp()

  else:
    echo &"Unknown command: '{command}'"
    showHelp()
