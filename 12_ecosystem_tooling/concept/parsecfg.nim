# std/parsecfg — INI-style configuration file parser
#   nim c -r parsecfg.nim

import std/parsecfg
import std/os

# Create a sample INI file for demonstration
let sampleIni = """
[server]
host = localhost
port = 8080
debug = true

[database]
name = myapp.db
user = admin
pass = secret123

[logging]
level = info
file = /var/log/myapp.log
"""

let iniPath = "/tmp/nim_parsecfg_demo.ini"
writeFile(iniPath, sampleIni)

# ── Load config ─────────────────────────────────────────────────────────

var cfg = loadConfig(iniPath)

# ── Read section values ────────────────────────────────────────────────

let host = cfg.getSectionValue("server", "host")
let port = cfg.getSectionValue("server", "port")
let dbName = cfg.getSectionValue("database", "name")

echo "Server: ", host, ":", port
echo "Database: ", dbName

# ── List sections ──────────────────────────────────────────────────────

echo "\nSections in config:"
for s in sections(cfg):
  echo "  [", s, "]"

# ── Check key existence via default value trick ────────────────────────

# getSectionValue returns defaultVal (empty string) for missing keys,
# so we use a sentinel to distinguish "exists but empty" from "missing"
let sentinel = "\x00SENTINEL\x00"
let found = cfg.getSectionValue("server", "host", sentinel)
let missing = cfg.getSectionValue("server", "nonexistent", sentinel)

echo "\n'server.host' exists? ", found != sentinel
echo "'server.nonexistent' exists? ", missing != sentinel

# ── Default values ─────────────────────────────────────────────────────

let fallback = cfg.getSectionValue("nonexistent", "key", "default_value")
echo "\nMissing key returns default: ", fallback

# ── String representation ──────────────────────────────────────────────

echo "\n── Full config ──"
echo $cfg

# Cleanup
removeFile(iniPath)