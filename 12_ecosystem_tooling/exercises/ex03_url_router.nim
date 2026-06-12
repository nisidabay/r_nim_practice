# Exercise 3: URL Router with OOP — uri + method dispatch
#   nim c -r ex03_url_router.nim
#
# Parses URLs and routes them to type-specific handlers via method dispatch.
# Demonstrates: parseUri, ref object with of, method vs proc dispatch

import std/uri

# ── OOP hierarchy ───────────────────────────────────────────────────────

type
  UrlHandler = ref object of RootObj
    name: string

  HttpHandler = ref object of UrlHandler
    timeout: int

  FtpHandler = ref object of UrlHandler
    passiveMode: bool

  FileHandler = ref object of UrlHandler
    basePath: string

# Constructors
proc newHttpHandler(name: string): HttpHandler =
  HttpHandler(name: name, timeout: 30)

proc newFtpHandler(name: string): FtpHandler =
  FtpHandler(name: name, passiveMode: true)

proc newFileHandler(basePath: string): FileHandler =
  FileHandler(name: "file", basePath: basePath)

# ── Method dispatch ─────────────────────────────────────────────────────

method handle(h: UrlHandler; u: Uri): string {.base.} =
  "Default handler: no route for " & $u

method handle(h: HttpHandler; u: Uri): string =
  "HTTP [" & h.name & "] " & u.hostname & u.path &
  " (timeout: " & $h.timeout & "s)"

method handle(h: FtpHandler; u: Uri): string =
  "FTP  [" & h.name & "] " & u.hostname & u.path &
  " (passive: " & $h.passiveMode & ")"

method handle(h: FileHandler; u: Uri): string =
  "FILE [" & h.name & "] " & h.basePath & u.path

# ── Proc dispatch (static — for comparison) ─────────────────────────────

proc describe(h: UrlHandler): string =
  "Handler: " & h.name

# ── Router ──────────────────────────────────────────────────────────────

proc route(handler: UrlHandler; url: string): string =
  let u = parseUri(url)
  handler.handle(u)  # dynamic dispatch via method

# ── Demo ────────────────────────────────────────────────────────────────

let handlers: seq[UrlHandler] = @[
  newHttpHandler("web"),
  newFtpHandler("mirror"),
  newFileHandler("/var/www"),
]

let urls = @[
  "https://nim-lang.org/docs/manual.html",
  "ftp://files.example.com/pub/release.tar.gz",
  "file:///index.html",
]

echo "── Method dispatch (dynamic) ──"
for i, handler in handlers:
  echo "  ", route(handler, urls[i])

echo "\n── Proc dispatch (static — always base type) ──"
for handler in handlers:
  echo "  ", describe(handler)

echo "\n── Type checks with `of` ──"
for handler in handlers:
  if handler of HttpHandler:
    echo "  ", handler.name, " is an HTTP handler"
  elif handler of FtpHandler:
    echo "  ", handler.name, " is an FTP handler"
  elif handler of FileHandler:
    echo "  ", handler.name, " is a File handler"