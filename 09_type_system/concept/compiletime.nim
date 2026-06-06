# Nim runs code DURING compilation. Results get baked into the binary.
# Runtime pays zero for what the compiler already computed.

import std/strutils

# ── const: computed at compile time, exists as bytes in the binary ────

proc slowSetup(): string =
  echo ">> This runs at COMPILE TIME <<"   # prints during `nim c`
  for i in 0..100_000: discard
  "ready"

const STATUS = slowSetup()    # runs once, during compilation
echo STATUS                    # "ready" — zero cost at runtime


# ── static[T]: force an argument to be known at compile time ──────────

proc tableSize(T: typedesc, maxSize: static[int]): int = maxSize * 2

const size = tableSize(int, 100)      # OK — 100 is literal
# const s2 = tableSize(int, myVar)    # ERROR — myVar is runtime value


# ── staticRead: embed any file into the binary ────────────────────────

const HOSTNAME = staticRead("/etc/hostname")
echo HOSTNAME.strip()          # contents baked in — no fopen at runtime


# ── when: compile-time if — dead branches NEVER compile ───────────────

when defined(release):
  echo "Release build"
elif defined(danger):
  echo "Danger build"
else:
  echo "Debug build"

when hostOS == "linux":
  echo "Linux-specific code compiled in"
  # Mac/Windows branches don't exist in this binary at all.
