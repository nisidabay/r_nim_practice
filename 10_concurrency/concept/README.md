# 10 Concurrency — Async and Threads

## Quick Start

```bash
nim c -r --threads:on 10_concurrency/concept/async.nim
nim c -r --threads:on 10_concurrency/concept/threads.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `async.nim` | Async HTTP server with asyncdispatch | Thousands of connections, no threads |
| `threads.nim` | Threads + channels: parallel processing | `createThread`, `Channel[T]` for safe data transfer |

## Common Patterns

```nim
# Threads with channels
var chan: Channel[string]
chan.open()
createThread(threadFunc, chan)
chan.send("data")
let reply = chan.recv()
```

## Test it

Run `test_it.nim` — it spawns 3 threads, each doing a calculation, and
collects results with a `Channel`. Change the number of threads, try
heavier tasks, see how it speeds up.
