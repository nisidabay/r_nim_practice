# You're writing a financial app. All money is float64. Someone passes
# dollars where euros were expected. Code compiles. No error. Wrong results.
#
# Nim's `distinct` creates types that share a representation but are NOT
# interchangeable. The compiler catches the mixup — not your test suite.

type
  Euros = distinct float64
  Dollars = distinct float64

var
  price: Euros = 19.99.Euros
  wallet: Dollars = 50.0.Dollars    # will be used in examples below

# price + wallet   # compile ERROR: can't mix Euros and Dollars
# wallet * 2       # compile ERROR: Dollars have no arithmetic yet
discard wallet  # keep for the commented-out examples

# Give distinct types only the operations you want:
proc `$`(e: Euros): string = "€" & $float64(e)

proc `+`(a, b: Euros): Euros =
  Euros(float64(a) + float64(b))

proc `*`(a: Euros, qty: int): Euros =
  Euros(float64(a) * float64(qty))

echo price + price           # €39.98
echo price * 3               # €59.97 — three items

# price + wallet              # STILL an error — we never defined Euros+Dollars

# ── Explicit conversion: never accidental ─────────────────────────────

const Rate = 1.09            # 1 Euro = 1.09 Dollars

proc toDollars(e: Euros): Dollars = Dollars(float64(e) * Rate)

echo "€", float64(price), " = $", float64(price.toDollars())


# ── Beyond currency: any "same data, different meaning" ───────────────

type
  UserId = distinct int
  PostId = distinct int

var
  user: UserId = 42.UserId
  post: PostId = 10.PostId

# user == post                    # ERROR — comparing UserId to PostId
discard user
discard post

# This prevents:
#   - Fetching a post with a user ID (wrong row, right type)
#   - Passing raw values between security contexts
# The compiler becomes your guardrail.
