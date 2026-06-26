# nim c -r test_password.nim
# Test getCharset — pure function, zero setup needed.
import std/unittest
import password

suite "getCharset":
  test "weak charset is lowercase + digits":
    check getCharset(cmpWeak) == "abcdefghijklmnopqrstuvwxyz0123456789"

  test "medium includes uppercase":
    check 'A' in getCharset(cmpMedium)
    check getCharset(cmpMedium).len == 62

  test "strong includes special chars":
    check '!' in getCharset(cmpStrong)

  test "very strong has all categories":
    let s = getCharset(cmpVeryStrong)
    check s.len > 90
    check '/' in s
