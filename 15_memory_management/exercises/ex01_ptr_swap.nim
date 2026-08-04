# Exercise 1: Swap two integers in place with ptr / addr
#
# Goal: write the body of `swapInPlace` so it swaps two ints in place,
# using the raw pointers `a` and `b`. When you finish, `x` and `y` trade
# values WITHOUT copying them through a third named variable.
#
# How to work this stub:
#   1. Fill in the body of `swapInPlace`. Its parameters `a` and `b` are
#      `ptr int` — raw pointers to the two integers you must swap.
#      Read through a pointer with `p[]`; write through it with `p[] =`.
#   2. Fix the driver so it passes the addresses `addr(x)` / `addr(y)`.
#
# The stub compiles and runs AS-IS — it prints an un-swapped "stub"
# result (x stays 10, y stays 20). Fix the marked lines and the output
# becomes a true swap: x = 20, y = 10.
#
# Run: nim c -r --hints:off ex01_ptr_swap.nim

proc swapInPlace(a, b: ptr int): void =
  # Swap the values the two pointers own, in place.
  #   let tmp = a[]      # save what a points to
  #   a[] = b[]          # copy b's value into a's location
  #   b[] = tmp          # put the saved value into b's location
  #
  # IMPLEMENT ME: write the three lines above, then delete this body so
  # the swap actually happens.
  discard a
  discard b

proc main() =
  var x = 10
  var y = 20
  echo "before: x = ", x, " y = ", y

  # IMPLEMENT ME: pass the address of each mutable var.
  #   swapInPlace(addr(x), addr(y))
  echo "stub:   x = ", x, " y = ", y     # unchanged until you fix it

  # Expected output once completed:
  echo "expect: x = 20 y = 10"

main()
