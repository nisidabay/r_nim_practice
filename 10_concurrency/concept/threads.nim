# Threads + Channels — parallel execution with message passing
#
# The problem: you have 1000 files to process. Processing one file takes
# ~100ms. Sequential: 100 seconds. On a 16-core machine, that's 15 idle
# cores doing nothing.
#
# Solution: spawn N threads, each processes a chunk of files. Communicate
# results through channels (thread-safe queues). No shared mutable state,
# no mutexes, no data races.

import std/[os, threadpool, cpuinfo]

# ── The channel: thread-safe message passing ──────────────────────────

# A channel is a typed, thread-safe queue.
# Worker threads send results; main thread collects them.

type
  FileResult = object
    path: string
    size: int64
    error: string    # empty if success

var resultChannel: Channel[FileResult]
resultChannel.open()   # Initialize the channel (required before use)


# ── The worker: processes one file, sends result ──────────────────────

proc processFile(filepath: string) =
  try:
    let size = getFileSize(filepath)
    resultChannel.send(FileResult(path: filepath, size: size))
  except OSError as e:
    resultChannel.send(FileResult(path: filepath, error: e.msg))


# ── Spawning threads ──────────────────────────────────────────────────

# 1. Collect file paths (scan a directory, or use a small test set)
let testDir = expandTilde("~")
var files: seq[string] = @[]

for path in walkDirRec(testDir):
  files.add(path)
  if files.len >= 50: break   # limit for this example

if files.len == 0:
  echo "No files found in ", testDir
  quit(1)

echo "Found ", files.len, " files to process"

# 2. Spawn one thread per file (for real work, use a thread pool)
for f in files:
  spawn processFile(f)
  # spawn() creates a new thread that runs processFile(f).
  # The thread pool manages the actual OS threads (limited to CPU count).

# 3. Collect results from the channel
var totalSize: int64 = 0
var processed = 0
var errors = 0

while processed < files.len:
  let result = resultChannel.recv()  # blocks until a result arrives
  processed += 1
  if result.error.len > 0:
    errors += 1
  else:
    totalSize += result.size

# 4. Sync: wait for all threads to finish
sync()
# sync() blocks until all spawned threads complete.

resultChannel.close()

echo "Results:"
echo "  Files processed: ", processed
echo "  Total size: ", totalSize, " bytes (", totalSize.float64 / 1_048_576.0, " MB)"
echo "  Errors: ", errors


# ── Thread pools: don't spawn 1000 threads for 1000 files ─────────────

# `spawn` uses Nim's thread pool (one thread per CPU core by default).
# If you spawn 1000 tasks, they queue up. Only N run concurrently (N = core count).
# This is automatic. You don't manage the pool. Nim does.

echo "\nCPU info: ", countProcessors(), " logical processors"


# ── Why channels instead of shared memory? ────────────────────────────
#
#   Shared memory + mutexes: easy to deadlock, data races are silent bugs.
#   Channels: each thread owns its data. Communication is explicit sends/receives.
#   The channel is the only shared thing — and it's lock-free internally.
#
#   This is the "communicate by sharing memory" vs "share memory by communicating"
#   distinction. Channels enforce the safer pattern.

# ── Thinking in Nim ────────────────────────────
# Nim's threads don't share mutable state by default — you communicate
# through typed Channels instead of mutexes. `spawn` rides Nim's thread pool
# (one OS thread per core), so you describe tasks, not threads. This is
# "share memory by communicating," the safe pattern that avoids data races.
