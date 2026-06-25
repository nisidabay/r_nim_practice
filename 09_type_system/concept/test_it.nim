# 09 Type System — Test It
# Distinct types: Celsius and Fahrenheit — the compiler keeps them separate.

type
  Celsius = distinct float
  Fahrenheit = distinct float

# Conversion procs
proc toFahrenheit(c: Celsius): Fahrenheit =
  let cVal = float(c)
  result = Fahrenheit(cVal * 9.0 / 5.0 + 32.0)

proc toCelsius(f: Fahrenheit): Celsius =
  let fVal = float(f)
  result = Celsius((fVal - 32.0) * 5.0 / 9.0)

# Converter for seamless conversion
converter toF(c: Celsius): Fahrenheit = c.toFahrenheit()
converter toC(f: Fahrenheit): Celsius = f.toCelsius()

let boiling = Celsius(100.0)
let freezing = Fahrenheit(32.0)

echo "100°C = ", float(boiling.toFahrenheit()), "°F"
echo "32°F = ", float(freezing.toCelsius()), "°C"

# Uncomment this line — it will NOT compile:
# let sum = Celsius(20.0) + Fahrenheit(68.0)
# Error: type mismatch: got (Celsius, Fahrenheit)

echo "\nDistinct types prevented mixing Celsius and Fahrenheit at compile time."

# Try defining Kelvin as another distinct type.
# Try adding arithmetic operators (+, -) for Celsius.
