# std/uri — URL parsing, encoding, and reconstruction
#   nim c -r uri.nim

import std/uri

# ── Parse a URL ─────────────────────────────────────────────────────────

let url = parseUri("https://user:pass@api.example.com:8080/path/to/resource?query=value&page=1#section")

echo "Scheme:   ", url.scheme
echo "Username: ", url.username
echo "Password: ", url.password
echo "Hostname: ", url.hostname
echo "Port:     ", url.port
echo "Path:     ", url.path
echo "Query:    ", url.query
echo "Anchor:   ", url.anchor

# ── Reconstruct ─────────────────────────────────────────────────────────

echo "\nReconstructed: ", $url  # stringify via $ operator

# ── Query encoding ──────────────────────────────────────────────────────

echo "\nEncoded: ", encodeQuery({"name": "Nim language", "version": "2.2"})

echo "\nDecoded pairs:"
for key, val in decodeQuery("name=Nim+language&version=2.2"):
  echo "  ", key, " = ", val

# ── Build a URL from parts ──────────────────────────────────────────────

var builder = initUri()
builder.scheme = "https"
builder.hostname = "nim-lang.org"
builder.path = "/docs/manual.html"
builder.query = "version=2.0"

echo "\nBuilt URL: ", $builder