# Option[T] is either some(value) or none(T). The compiler forces you to
# check before unwrapping. No null dereference, no forgotten nil check.
# NOTE: Option[T] uses generics — that [T] means "any type". See Module 09.

import std/options

type
  User = object
    id: int
    username: string
    role: string

proc findUser(id: int): Option[User] =
  if id == 1: some(User(id: 1, username: "carlos", role: "admin"))
  elif id == 2: some(User(id: 2, username: "alice", role: "viewer"))
  else: none(User)

# ── Safe unwrapping: you MUST check before .get() ────────────────────

let result = findUser(3)
# echo result.username   # compile ERROR — Option[User], not User

if result.isSome():
  echo "Found: ", result.get().username
else:
  echo "User not found"


# ── map: transform only if present ────────────────────────────────────

proc displayName(u: User): string = u.username & " [" & u.role & "]"

echo findUser(1).map(displayName)    # some("carlos [admin]")
echo findUser(99).map(displayName)   # none(string) — nothing to transform


# ── filter: keep only if condition passes ─────────────────────────────

proc isAdmin(u: User): bool = u.role == "admin"

echo findUser(2).filter(isAdmin).isSome()  # false — alice is not admin


# ── flatMap: when the transformation also returns an Option ───────────

proc getPermissions(u: User): Option[string] =
  if u.role == "admin": some("full_access") else: none(string)

echo findUser(1).flatMap(getPermissions)   # some("full_access")
# Without flatMap: Option[Option[string]] — nested mess

# Option[T] vs exceptions:
#   Option[T] — use when "no value" is a normal possibility (e.g., not found, empty)
#   try/except — use when failure is exceptional (e.g., network error, invalid data)
# Both are valid; prefer Option for expected absences, exceptions for surprises.
