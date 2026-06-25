# nim c -r control_flow.nim

echo "=== if/elif/else ==="

let score = 85
if score >= 90:
  echo "A"
elif score >= 80:
  echo "B"
else:
  echo "C or lower"

# No parentheses needed. No brackets. Indentation IS the block.

echo "\n=== case/of ==="

let grade = "B"
case grade
of "A": echo "Excellent"
of "B", "C": echo "Pass"
else: echo "Retake"

# case works with strings too:
let name = "Carlos"
case name
of "Carlos": echo "Hola!"
else: echo "Who?"
