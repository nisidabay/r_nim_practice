# nim c -r --threads:on downloader.nim <url> <url> ...
# Download multiple files in parallel using threads.
import std/[httpclient, os, strutils]

when defined(windows):
  echo "This tool uses Unix-style threading"
  quit(1)

if paramCount() < 1:
  echo "Usage: downloader <url> [url ...]"
  quit(1)

# Sequential version — stable, no deprecated threadpool
# For real parallelism, use malebolgia or taskpools nimble packages
import std/strformat

for i in 1..paramCount():
  let url = paramStr(i)
  var client = newHttpClient()
  try:
    let content = client.getContent(url)
    let filename = url.split('/')[^1]
    if filename.len == 0:
      echo fmt"✗ {url} (no filename)"
      continue
    writeFile(filename, content)
    echo fmt"✓ {filename} ({content.len} bytes)"
  except:
    echo fmt"✗ {url} FAILED"
