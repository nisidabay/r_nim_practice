# 03 Procedures — Test It
# Format currency with a proc and UFCS.

import std/strformat

proc formatCurrency(amount: float, symbol: string): string =
  result = fmt"{symbol}{amount:.2f}"

# Direct call
echo formatCurrency(19.99, "$")

# UFCS call (same thing, pipeline style)
echo 19.99.formatCurrency("$")
echo 3.5.formatCurrency("€")
echo 999.0.formatCurrency("¥")

# Try changing the number of decimal places.
# Try adding thousands separators (e.g. $1,234.56).
# Try using `func` instead of `proc`.
