# Async HTTP server — handle thousands of connections, not one at a time
#
# The problem: your web server can only handle one client at a time. While
# it waits for client A's database query, client B times out. You need to
# handle B while A is waiting.
#
# The old way: threads. One thread per client. Fine for 10 clients,
# collapses at 10,000 (thread overhead, context switching, memory).
#
# Nim's way: async/await. One thread, many coroutines. When a coroutine
# awaits I/O, the thread moves to the next coroutine. No blocking.

import std/[asyncdispatch, asynchttpserver, strutils, json]

# ── An async HTTP server in ~30 lines ─────────────────────────────────

proc handleRequest(req: Request): Future[void] {.async.} =
  # {.async.} transforms this proc into an async coroutine.
  # `await` suspends execution here, allowing other requests to run.
  # When the awaited operation completes, execution resumes.

  case req.url.path
  of "/":
    await req.respond(Http200, "Nim async server — running!")
  of "/health":
    await req.respond(Http200, "OK")
  of "/echo":
    # Echo back the body the client sent
    await req.respond(Http200, req.body)
  of "/info":
    let info = %*{
      "server": "Nim",
      "method": $req.reqMethod,
      "headers": %*{"count": req.headers.len}
    }
    await req.respond(Http200, $info)
  else:
    await req.respond(Http404, "Not found: " & req.url.path)

proc main() {.async.} =
  var server = newAsyncHttpServer()
  echo "Server starting on http://localhost:8080"
  echo "Try: curl localhost:8080/ ; curl -X POST localhost:8080/echo -d 'hello'"
  server.listen(Port(8080))

  # The loop: accept connections forever. Each gets its own coroutine.
  # While one coroutine is `await`-ing a database or file read,
  # the server accepts and handles other connections.
  while true:
    if server.shouldAcceptRequest():
      let future = server.acceptRequest(handleRequest)
      # Don't await here! That would block. Let asyncdispatch run it.
      asyncCheck future

when isMainModule:
  asyncCheck main()
  runForever()
  # runForever() runs the event loop. It never returns. Ctrl+C to stop.


# ── What async actually does ──────────────────────────────────────────
#
#   {.async.} rewrites your proc into a state machine.
#   Every `await` is a suspension point.
#   asyncdispatch runs a loop: pick a ready coroutine, run until next await, repeat.
#
#   One OS thread. Thousands of concurrent connections. No thread overhead.
#   Same model as Node.js, Python asyncio, Go goroutines.
#
# ── To test ───────────────────────────────────────────────────────────
#   nim c -r --threads:on async_http.nim
#   # In another terminal:
#   curl localhost:8080/
#   curl -X POST localhost:8080/echo -d "nim is fast"
#   curl localhost:8080/info
