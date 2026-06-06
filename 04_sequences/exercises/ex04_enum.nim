# Exercise 4: Enums
type Semaforo = enum
  rojo, amarillo, verde

for s in rojo..verde:
  echo s, " = ", ord(s)
