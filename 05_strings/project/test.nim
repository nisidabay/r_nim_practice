import std/[os, md5, strformat, parseopt, strutils]

proc showHelp() =
  echo "Nim Hash Generator"
  echo "A local hash md5 tool"
  echo "\nUsage:"
  echo "  hash -m <file name>"
  echo "\nArguments:"
  echo "  <file name>        The file name to hash"
  echo "\nOptions:"
  echo "  -h, --help         Show this menu"
  echo "  -m, --make         Make the hash of the file"
  echo "\nExample:"
  echo "  hash -m my_file.txt"
  quit(0)

proc makeHashes(filePath: string) =
  if not fileExists(filePath):
    echo "File ", filePath, " does not exist."
    quit(1)

  var content: string

  try:
    content = readFile(filePath)
  except IOError as e:
    echo fmt"Error reading file: {filePath}, {e.msg}"
    quit(1)

  let md5sum = $toMD5(content)
  echo "MD5(", filePath, ") = ", md5sum

proc main() =
  var p = initOptParser()
  var make = false
  var filePath: string

  if paramCount() == 0:
    showHelp()

  for kind, key, val in p.getopt():
    case kind
    of cmdLongOption, cmdShortOption:
      case key.toLowerAscii()
      of "h", "help": showHelp()
      of "m", "make": make = true
    of cmdArgument:
      if filePath.len == 0:
        filePath = key
      else:
        echo "Error: Only one file can be processed at a time."
        showHelp()
    of cmdEnd: discard

  if make and filePath.len > 0:
    makeHashes(filePath)
  else:
    showHelp()

when isMainModule:
  main()

