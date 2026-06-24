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
