version = "0.1.0"
author = "r_nim_practice"
description = "Log analyzer CLI — ecosystem tooling demo using parsecfg, parsecsv, terminal, logging, and OOP"
license = "MIT"
bin = @["log_analyzer"]
require "nim >= 2.2.6"

# Dependencies (all stdlib — no external packages needed)

task build, "Compile the binary":
  exec "nim c log_analyzer.nim"

task run, "Compile and run":
  exec "nim c -r log_analyzer.nim"

task clean, "Remove build artifacts":
  exec "rm -rf nimcache log_analyzer"