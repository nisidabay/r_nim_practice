# Exercise 2: Temperature Converter
# Convert Celsius to Fahrenheit and back.
# C → F: (C × 9/5) + 32
# F → C: (F - 32) × 5/9

proc celsiusToFahrenheit(celsius: float): float =
  (celsius * 9.0 / 5.0) + 32.0

proc fahrenheitToCelsius(fahrenheit: float): float =
  (fahrenheit - 32.0) * 5.0 / 9.0

let celsius = 25.0
let fahrenheit = celsiusToFahrenheit(celsius)
echo celsius, "°C = ", fahrenheit, "°F"

let f = 77.0
let c = fahrenheitToCelsius(f)
echo f, "°F = ", c, "°C"
