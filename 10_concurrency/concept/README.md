# 10 Concurrency — Async, Threads, and Pipes

## Quick Start

```bash
nim c -r --threads:on 10_concurrency/concept/async.nim
nim c -r --threads:on 10_concurrency/concept/threads.nim
nim c -r 10_concurrency/concept/pipes.nim
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `async.nim` | Async HTTP server with asyncdispatch | Thousands of connections, no threads |
| `threads.nim` | Threads + channels: parallel processing | `createThread`, `Channel[T]` for safe data transfer |
| `pipes.nim` | Process pipes: shell pipelines from Nim | `startProcess`, `readLine`, pipe data through external programs |

## Common Patterns

```nim
# Threads with channels
var chan: Channel[string]
chan.open()
createThread(threadFunc, chan)
chan.send("data")
let reply = chan.recv()

# Process pipe
let p = startProcess("ls", args = ["-la"])
for line in p.outputStream.lines: echo line
```

## Pónlo a prueba

Coge `threads.nim`, lanza 3 hilos que cada uno haga un cálculo,
recoge los resultados con un `Channel`. Cambia el número de hilos,
prueba con tareas más pesadas. Mira cómo se acelera.
