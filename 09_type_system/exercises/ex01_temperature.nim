# Exercise 1: Celsius / Fahrenheit
type
  Celsius = distinct float
  Fahrenheit = distinct float

proc toCelsius(f: Fahrenheit): Celsius =
  Celsius((f.float - 32.0) * 5.0 / 9.0)

proc toFahrenheit(c: Celsius): Fahrenheit =
  Fahrenheit(c.float * 9.0 / 5.0 + 32.0)

let hot = 100.0.Celsius
let f = hot.toFahrenheit()
echo f.float, "°F"
let c = f.toCelsius()
echo c.float, "°C"
