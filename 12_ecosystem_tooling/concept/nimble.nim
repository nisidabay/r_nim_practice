# nimble.nim — Nimble packaging reference
#
# NOTE: This file demonstrates the .nimble format via comments and echo.
# It does NOT compile standalone. To create a real Nimble package,
# write a .nimble file (see ../project/log_analyzer.nimble for an example).
# To use this file: read the comment blocks for the .nimble syntax reference.
#
# ── .nimble file format ─────────────────────────────────────────────────
#
# A .nimble file is a NimScript file (Nim code, not a module).
# Key fields:
#
# ```nim
# # Package metadata
# version       = "0.1.0"          # SemVer
# author        = "Your Name"
# description   = "What this package does"
# license       = "MIT"
#
# # Binary / library declaration
# bin = @["my_tool"]               # produces bin/my_tool
# # or for libraries:
# srcDir = "src"
#
# # Dependencies
# require "nim >= 2.0.0"
# require "regex"
# require "https://github.com/user/pkg >= 0.2.0"
#
# # Custom tasks
# task test, "Run tests":
#   exec "nim c -r tests/test_all.nim"
#
# task docs, "Generate documentation":
#   exec "nim doc src/package.nim"
# ```

echo "Nimble packaging reference"
echo ""
echo "Key .nimble directives:"
echo "  version, author, description, license — metadata"
echo "  bin = @[\"binary_name\"]           — produces a CLI binary"
echo "  require \"nim >= 2.2.6\"           — dependency declaration"
echo "  task name, \"description\":         — custom nimble tasks"
echo ""
echo "Common nimble commands:"
echo "  nimble build       — compile the package"
echo "  nimble run         — compile and run the binary"
echo "  nimble test        — run the 'test' task"
echo "  nimble install     — install system-wide"
echo "  nimble uninstall   — remove installed package"
echo "  nimble publish     — publish to nimble.directory"
echo ""
echo "See ../project/log_analyzer.nimble for a real example."
echo ""
echo "Tip: nimble init creates a scaffold .nimble file in the current dir."

# ── Thinking in Nim ────────────────────────────
# A Nimble package file is itself Nim code — plain NimScript — so your
# build tasks, version checks, and dependencies are expressed in the same
# language you write your program in, not a separate DSL with its own rules.