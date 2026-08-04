# Project: singly-linked list with ref object nodes
# Demonstrates ownership and sharing behaviour from the memory group:
#   - Node is a `ref object` — traced, freed by ARC when no one refs it.
#   - `new(n)` allocates a fresh ref on the heap (no manual dealloc).
#   - The list owns its first node; `next` chains own the next ones.
# Because every node is a ref, ARC frees the whole chain when `head`
# goes out of scope — no free loop needed.
#
# Run: nim c -r --hints:off linked_list.nim

type
  Node = ref object
    next: Node        # traced reference to the following node (or nil)
    data: int

  IntList = ref object
    head: Node
    length: int

# ── append: grow the list with a new ref node ─────────────────────────

proc append(list: IntList, value: int) =
  var newNode: Node
  new(newNode)                 # heap-allocate a fresh ref object
  newNode.data = value
  newNode.next = nil

  if list.head == nil:
    list.head = newNode        # first node becomes the head
  else:
    var cur = list.head
    while cur.next != nil:     # walk to the tail (last node)
      cur = cur.next
    cur.next = newNode         # chain the new node on the end

  inc list.length

# ── first / last: read through refs with `.` ──────────────────────────

proc first(list: IntList): int =
  return list.head.data

proc last(list: IntList): int =
  var cur = list.head
  while cur.next != nil:
    cur = cur.next
  return cur.data

# ── print: walk the chain, deref each node with `.` ───────────────────

proc display(list: IntList) =
  stdout.write("list = [")
  var cur = list.head
  while cur != nil:
    stdout.write($cur.data)
    if cur.next != nil:
      stdout.write(", ")
    cur = cur.next            # move to the next ref (nil stops us)
  echo "]"

proc main() =
  var list = IntList()        # empty list; head is nil
  echo "empty: length = ", list.length

  for v in [1, 2, 3, 4, 5]:
    list.append(v)

  echo "after append: length = ", list.length
  list.display()
  echo "first item = ", list.first
  echo "last  item = ", list.last

  # Sharing: `alias` points at the SAME list object, not a copy.
  # Mutating through it is visible through `list` — that's ref semantics.
  let alias = list
  alias.append(99)
  echo "after alias.append(99): length = ", list.length
  list.display()

  # No manual dealloc anywhere — ARC frees head and every next node when
  # this proc returns and the refs go out of scope.

main()
