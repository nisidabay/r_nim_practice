# NimPass Generator

A secure, local-first password management tool written in Nim.

## Overview

NimPass Generator is a lightweight command-line utility for generating and storing passwords securely on your local machine. It emphasizes simplicity, security, and privacy by storing all passwords locally without relying on external services or cloud storage.

## Features

- **Secure Password Generation**: Generate passwords using cryptographically secure random bytes from `/dev/urandom`
- **Multiple Complexity Levels**: Choose from 4 complexity levels to match your security requirements
- **Manual Password Entry**: Option to manually enter passwords (type or paste from clipboard)
- **Local Storage**: All passwords are stored locally in your Documents folder
- **Permission-Based Security**: Password files are created with restrictive permissions (0600)
- **Directory Protection**: Password directory is created with 0700 permissions

## Installation

### Prerequisites

- [Nim compiler](https://nim-lang.org/install.html) (version 1.6 or higher recommended)

### Build

```bash
# Clone or download the project
cd password_project

# Compile the project
nim c -d:release password.nim

# Optional: Install to system path
sudo cp password /usr/local/bin/nimpass
```

### Clipboard Support (for -m option)

For the clipboard paste functionality, you need one of the following tools installed:

- **xclip**: `sudo apt install xclip` (Ubuntu/Debian)
- **xsel**: `sudo apt install xsel` (Ubuntu/Debian)
- **wl-clipboard**: `sudo apt install wl-clipboard` (Wayland)

## Usage

```
Usage:
  password [options] <name>

Arguments:
  <name>              The service name (e.g., github)

Options:
  -h, --help          Show help menu
  -l, --length:N      Set password length (Default: 20)
  -c, --complexity:C  Set complexity: weak, medium, strong, very_strong
  -m, --manual        Enter password manually (type or paste from clipboard)
```

### Complexity Levels

| Level | Characters | Use Case |
|-------|------------|----------|
| `weak` | a-z, 0-9 | Non-critical services |
| `medium` | a-z, A-Z, 0-9 | Standard accounts |
| `strong` | a-z, A-Z, 0-9, special chars | Default, most accounts |
| `very_strong` | Full character set | High-security accounts |

## Examples

### Generate a default password (strong, 20 characters)

```bash
./password github
```

### Generate a longer password

```bash
./password -l:32 github
```

### Generate with specific complexity

```bash
./password -c:very_strong bank_account
```

### Combine length and complexity

```bash
./password -l:32 -c:very_strong personal_email
```

### Enter password manually

```bash
./password -m github
```

When using `-m` or `--manual`, you'll be prompted to choose:
1. **Type password manually** - Hidden input for security
2. **Paste from clipboard** - Reads current clipboard content

### Manual entry workflow

```
$ ./password -m github

Manual Password Entry
Choose input method:
  1. Type password manually
  2. Paste from clipboard
  Enter choice (1 or 2):
  > 1
Enter password (input hidden): 
✔ Saved manual password for 'github'
```

## Password Storage

Passwords are stored at:
```
~/Documents/Passwords/<name>.txt
```

### Storage Location Structure

```
~/Documents/
└── Passwords/          (0700 permissions)
    ├── github.txt      (0600 permissions)
    ├── bank.txt        (0600 permissions)
    └── email.txt       (0600 permissions)
```

## Security Considerations

1. **Cryptographic Randomness**: Passwords are generated using `sysrand` which reads from `/dev/urandom`

2. **File Permissions**: 
   - Password files: `0600` (read/write for owner only)
   - Password directory: `0700` (full access for owner only)

3. **Local Storage**: No data leaves your machine

4. **Manual Entry**: When using `-m`, passwords are read securely with hidden input

5. **Clipboard Warning**: When pasting from clipboard, the password remains in your clipboard - consider clearing it after use

## Notes

- When using `-m/--manual`, the `-l` and `-c` options are ignored since you're providing the password directly
- The `-m` flag allows you to import existing passwords or use passwords from password managers temporarily
- Always verify the storage directory has restrictive permissions

## License

This project is provided as-is for personal use. Modify and distribute as needed.

## Contributing

Feel free to submit issues or pull requests for:
- Bug fixes
- New features
- Documentation improvements
- Code optimizations