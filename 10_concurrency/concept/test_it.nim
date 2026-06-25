# 10 Concurrency — Test It
# Spawn 3 threads, each doing a calculation, collect results via Channel.
# Uses ONLY: threads, channels (taught in threads.nim).
# Compile with: nim c -r --threads:on 10_concurrency/concept/test_it.nim

type
  ThreadArgs = object
    id: int
    startIdx: int
    endIdx: int

  ThreadResult = object
    id: int
    value: float

var chan: Channel[ThreadResult]
chan.open()

proc worker(args: ThreadArgs) {.thread.} =
  # Calculate sum of 1/(i^2) — approximates pi^2/6 ≈ 1.6449
  var sum = 0.0
  for i in args.startIdx .. args.endIdx:
    sum += 1.0 / float(i * i)
  chan.send(ThreadResult(id: args.id, value: sum))

const
  NumThreads = 3
  MaxN = 100_000

var threads: array[NumThreads, Thread[ThreadArgs]]

# Launch threads with non-overlapping ranges
for i in 0 ..< NumThreads:
  let start = (MaxN div NumThreads) * i + 1
  let finish = (MaxN div NumThreads) * (i + 1)
  createThread(threads[i], worker, ThreadArgs(id: i + 1, startIdx: start, endIdx: finish))

# Collect results
var total = 0.0
for i in 0 ..< NumThreads:
  let res = chan.recv()
  echo "Thread ", res.id, " finished: sum = ", res.value
  total += res.value

echo "Total sum of 1/(n^2) = ", total
echo "Expected value (pi^2/6) ≈ 1.6449"

# Try changing NumThreads to 1, 5, 10.
# Try a different calculation (e.g. Monte Carlo pi estimation).
