# nim c -r fallback.nim <url> [url ...]
# Try fetching URLs in order — stop at first success.
# std/httpclient is not covered in this course — it's a web API client.
# Usage: newHttpClient(), getContent(url), close(). Requires internet.
import std/[httpclient, strutils, os]

if paramCount() < 1:
  echo "Usage: fallback <url1> [url2 ...]"
  echo "  Tries URLs in order, returns first success."
  quit(1)

var client = newHttpClient()
for i in 1..paramCount():
  let url = paramStr(i)
  try:
    echo "Trying: ", url
    let response = client.getContent(url)
    echo "✓ ", url, " OK (", response.len, " bytes)"
    echo response[0..min(response.high, 200)]
    quit(0)
  except:
    echo "✗ ", url, " failed"

echo "All URLs failed."
