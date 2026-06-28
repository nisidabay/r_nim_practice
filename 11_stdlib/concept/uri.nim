# std/uri — parseUri, Uri fields, URL construction
#   nim c -r concept/uri.nim

import std/uri

# ── Parsing a URL ───────────────────────────────────────────────────────

let url = parseUri("https://nim-lang.org/docs/manual.html?q=macro#section-1")

echo "scheme:   ", url.scheme     # https
echo "hostname: ", url.hostname   # nim-lang.org
echo "path:     ", url.path       # /docs/manual.html
echo "query:    ", url.query      # q=macro
echo "anchor:   ", url.anchor     # section-1
echo "port:     ", url.port       # (empty — default for scheme)
echo "full:     ", $url           # https://nim-lang.org/docs/manual.html?q=macro#section-1

# ── Different URL shapes ─────────────────────────────────────────────────

let urls = [
  "ftp://files.example.com/pub/release.tar.gz",
  "file:///var/www/index.html",
  "http://localhost:8080/api/status",
  "mailto:user@example.com",
]

for raw in urls:
  let u = parseUri(raw)
  echo u.scheme, " → host: ", u.hostname, ", path: ", u.path,
       ", port: ", u.port

# ── Building URLs ────────────────────────────────────────────────────────

var u2 = initUri()
u2.scheme = "https"
u2.hostname = "api.example.com"
u2.path = "/search"
u2.query = "q=nim"
echo "built: ", $u2              # https://api.example.com/search?q=nim

# ── Verification ────────────────────────────────────────────────────────

let u3 = parseUri("https://nim-lang.org:8080/docs")
assert u3.scheme == "https"
assert u3.hostname == "nim-lang.org"
assert u3.port == "8080"
assert u3.path == "/docs"

echo "All URI assertions passed."
