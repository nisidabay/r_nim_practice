# std/os — environment, filesystem, process, and path operations
#   nim c -r concept/os_module.nim

import std/os

# ── Environment ──────────────────────────────────────────────────────────

echo "getEnv(PATH) = ", getEnv("PATH")              # your $PATH
echo "getEnv(MISSING, default) = ", getEnv("MISSING", "fallback")  # "fallback"
echo "existsEnv(HOME) = ", existsEnv("HOME")         # true

# ── Home / App path ──────────────────────────────────────────────────────

echo "getHomeDir() = ", getHomeDir()                 # /home/user
echo "getAppFilename() = ", getAppFilename()         # /path/to/binary

# ── Sleep ────────────────────────────────────────────────────────────────

echo "Sleeping for 10 ms..."
sleep(10)
echo "Done."

# ── Shell commands ───────────────────────────────────────────────────────

# execShellCmd runs a shell command; returns exit code (0 = success)
let exitCode = execShellCmd("echo 'Hello from shell!'")
echo "execShellCmd exit code: ", exitCode

# ── Directory ops ────────────────────────────────────────────────────────

let tmp = "/tmp/nim_os_demo"
createDir(tmp)
echo "createDir: ", tmp, " exists? ", dirExists(tmp)   # true

# existsOrCreateDir is the same as createDir (creates parents too)
let nested = tmp / "a" / "b" / "c"
createDir(nested)
echo "nested dir exists? ", dirExists(nested)           # true

# ── File ops ─────────────────────────────────────────────────────────────

let src = tmp / "source.txt"
let dst = tmp / "dest.txt"
writeFile(src, "hello world")
copyFile(src, dst)
echo "copyFile: both exist? ", fileExists(src), " ", fileExists(dst)  # true true

moveFile(src, tmp / "moved.txt")
echo "moveFile: src gone? ", fileExists(src)            # false
echo "moveFile: dst here? ", fileExists(tmp / "moved.txt")  # true

# Cleanup
removeDir(tmp)
echo "cleanup: /tmp/nim_os_demo exists? ", dirExists(tmp)  # false