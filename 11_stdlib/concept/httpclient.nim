# std/httpclient — fetch URLs, download files, make HTTP requests
#   nim c -r concept/httpclient.nim
#
# Requires internet access. Used in fallback.nim and parallel_downloader.nim.

import std/httpclient

# ── Basic GET ───────────────────────────────────────────────────────────

var client = newHttpClient()

# fetch() returns the full response as a string
let body = client.getContent("https://httpbin.org/get")
echo "Response length: ", body.len, " chars"
echo "First 100 chars:"
echo body[0 .. min(body.high, 100)]

echo ""

# ── GET with full response ──────────────────────────────────────────────

let response = client.get("https://httpbin.org/anything")
echo "Status: ", response.status          # "200 OK"
echo "Body length: ", response.body.len
echo "Headers:"
for k, v in response.headers:
  echo "  ", k, ": ", v

client.close()

# ── Download and save to file ───────────────────────────────────────────

# The parallel_downloader.nim project uses this pattern:
#   let content = client.getContent(url)
#   writeFile(filename, content)

# ── Timeout ──────────────────────────────────────────────────────────────

# newHttpClient() accepts a timeout in milliseconds (default = 5000)
var fastClient = newHttpClient(timeout = 2000)  # 2 second timeout
try:
  let data = fastClient.getContent("https://httpbin.org/delay/5")
  echo "Got: ", data.len, " bytes"
except:
  echo "Timed out after 2s (expected — endpoint has 5s delay)"

# ── Try it yourself ─────────────────────────────────────────────────────
# Change the URL, try different endpoints.
# Add error handling for network failures.
# See the parallel_downloader.nim and fallback.nim projects for real usage.

# ── Thinking in Nim ────────────────────────────
# std/httpclient turns HTTP into a typed API: newHttpClient() with a
# configurable timeout, getContent() for the body as a string, get() for
# the full response incl. status and headers. Always close the client to
# release the connection after your requests.
