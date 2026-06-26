# nim c -r --threads:on parallel_downloader.nim <url> <url> ...
# Download multiple URLs concurrently using threads + channels.
# std/httpclient is not covered in this course — it's a web API client.
# Usage: newHttpClient(), getContent(url), close(). Requires internet.
import std/[httpclient, os, strutils, threadpool]

type
  Result = object
    url: string
    ok: bool
    msg: string

var ch: Channel[Result]

proc download(url: string) =
  var client = newHttpClient()
  try:
    let content = client.getContent(url)
    let filename = url.split('/')[^1]
    let name = if filename.len > 0: filename else: "index.html"
    writeFile(name, content)
    ch.send(Result(url: url, ok: true, msg: $content.len & " bytes"))
  except:
    ch.send(Result(url: url, ok: false, msg: getCurrentExceptionMsg()))

ch.open()

if paramCount() < 1:
  echo "Usage: parallel_downloader <url> [url ...]"
  echo "  e.g. parallel_downloader https://example.com/file"
  quit(1)

var urls: seq[string] = @[]
for i in 1..paramCount():
  urls.add(paramStr(i))

let total = urls.len

# Process in batches of maxConcurrent to limit simultaneous connections.
# Without this, 1000 URLs would spawn 1000 threads at once.
const maxConcurrent = 10
for i in countup(0, urls.high, maxConcurrent):
  let batch = urls[i .. min(i + maxConcurrent - 1, urls.high)]
  for url in batch:
    spawn download(url)
  sync()

var results: seq[Result] = @[]
for i in 0 ..< total:
  results.add(ch.recv())

ch.close()

for r in results:
  if r.ok:
    echo "[OK] ", r.url, " — ", r.msg
  else:
    echo "[FAIL] ", r.url, " — ", r.msg