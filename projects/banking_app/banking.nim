# Nim - bank application
#
# Uses ref object and sequences to fake a database

import std/[strutils, strformat, sha1]
import mask_entry

# --- Data Structures ---
# We use 'ref object' so instances are passed by reference.
type
  User = ref object
    username: string
    passwordHash: string
    balance: float

# This sequence acts as our "Database"
var userDB: seq[User] = @[]

# --- Helper Functions ---

# Returns the User object if found, otherwise nil
proc findUser(username: string): User =
  for user in userDB:
    if user.username == username:
      return user
  return nil

proc pressEnterToContinue() =
  echo "\nPress Enter to continue..."
  discard readLine(stdin)

# --- Feature 1: Creation of Account ---

proc createAccount() =
  echo "\n=== Create New Account ==="

  write(stdout, "Enter Username: ")
  let username = readLine(stdin).strip()

  if username.len == 0:
    echo "Error: Username cannot be empty."
    return

  if findUser(username) != nil:
    echo "Error: Username already exists!"
    return

  write(stdout, "Enter Password: ")
  let password = readPasswordWithAsterisks()
  if password.len == 0:
    echo "Error: Password cannot be empty."
    return

  # Create new user with 0.00 initial balance
  let newUser = User(username: username, passwordHash: $sha1.secureHash(
      password), balance: 0.0)
  userDB.add(newUser)

  echo fmt"Success! Account created for '{username}'."

# --- Feature 2: Login Functionality ---

proc login(): User =
  echo "\n=== User Login ==="

  write(stdout, "Username: ")
  let username = readLine(stdin).strip()

  write(stdout, "Password: ")
  let password = readPasswordWithAsterisks()

  let user = findUser(username)

  if user != nil and user.passwordHash == $sha1.secureHash(password):
    echo fmt"Welcome back, {user.username}!"
    return user
  else:
    echo "Invalid credentials."
    return nil

# --- Feature 3: Check Amount ---

proc checkBalance(currentUser: User) =
  echo "\n=== Account Details ==="
  echo fmt"Account Holder: {currentUser.username}"
  echo fmt"Current Balance: ${currentUser.balance:.2f}"

# --- Feature 4: Transfer Money ---

proc transferMoney(currentUser: User) =
  echo "\n=== Transfer Money ==="

  write(stdout, "Enter Recipient Username: ")
  let recipientName = readLine(stdin).strip()

  if recipientName == currentUser.username:
    echo "Error: You cannot transfer money to yourself."
    return

  let recipient = findUser(recipientName)
  if recipient == nil:
    echo "Error: Recipient account not found."
    return

  write(stdout, "Enter Amount to Transfer: ")
  let amountStr = readLine(stdin).strip()

  try:
    let amount = parseFloat(amountStr)

    # Validations
    if amount <= 0:
      echo "Error: Amount must be greater than zero."
    elif amount > currentUser.balance:
      echo fmt"Error: Insufficient funds. Your balance is ${currentUser.balance:.2f}."
    else:
      # Perform Transaction
      currentUser.balance -= amount
      recipient.balance += amount
      echo "\n--- Transaction Successful ---"
      echo fmt"Sent: ${amount:.2f}"
      echo fmt"To: {recipient.username}"
      echo fmt"New Balance: ${currentUser.balance:.2f}"

  except ValueError:
    echo "Error: Please enter a valid number."

# --- Bonus: Deposit (To make testing easier) ---

proc depositMoney(currentUser: User) =
  echo "\n=== Deposit Money ==="
  write(stdout, "Enter Amount to Deposit: ")
  try:
    let amount = parseFloat(readLine(stdin))
    if amount > 0:
      currentUser.balance += amount
      echo fmt"Deposited ${amount:.2f}. New Balance: ${currentUser.balance:.2f}"
    else:
      echo "Amount must be positive."
  except ValueError:
    echo "Invalid amount."

# --- Menus & Logic Flow ---

proc userDashboard(currentUser: User) =
  while true:
    echo "\n----------------------------"
    echo fmt"Logged in as: {currentUser.username}"
    echo "1. Check Balance"
    echo "2. Transfer Money"
    echo "3. Deposit Money (Simulate ATM)"
    echo "4. Logout"
    write(stdout, "Select option: ")

    let choice = readLine(stdin).strip()

    case choice:
    of "1":
      checkBalance(currentUser)
      pressEnterToContinue()
    of "2":
      transferMoney(currentUser)
      pressEnterToContinue()
    of "3":
      depositMoney(currentUser)
      pressEnterToContinue()
    of "4":
      echo "Logging out..."
      break
    else:
      echo "Invalid option."

proc main() =
  # Pre-seed a user for testing purposes
  userDB.add(User(username: "admin", passwordHash: $sha1.secureHash("123"),
      balance: 5000.00))

  while true:
    echo "\n============================"
    echo "      NIM BANKING APP       "
    echo "============================"
    echo "1. Create Account"
    echo "2. Login"
    echo "3. Exit"
    write(stdout, "Select option: ")

    let choice = readLine(stdin).strip()

    case choice:
    of "1":
      createAccount()
      pressEnterToContinue()
    of "2":
      let user = login()
      if user != nil:
        userDashboard(user)
      else:
        pressEnterToContinue()
    of "3":
      echo "Goodbye!"
      quit(0)
    else:
      echo "Invalid option."

# --- Entry Point ---
if isMainModule:
  main()

