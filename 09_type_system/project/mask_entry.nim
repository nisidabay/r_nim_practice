# Nim - hide password
#
# Uses terminal getch() and mask the input with "*"
import std/terminal

proc readPasswordWithAsterisks*(): string =
  var password = ""

  while true:
    let c = getch() # Read a single character without echoing

    case c
    of '\r', '\n': # Enter key pressed
      stdout.write("\n")
      break
    of '\b', '\x7f': # Backspace key (Windows/Unix)
      if password.len > 0:
        password.setLen(password.len - 1)
        # Move cursor back, overwrite with space, move back again
        stdout.write("\b \b")
    of '\x03': # Ctrl+C (End of text)
      raise newException(IOError, "Keyboard Interrupt")
    else:
      password.add(c)
      stdout.write("*") # Echo an asterisk instead of the char

  return password
