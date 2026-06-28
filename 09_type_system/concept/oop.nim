# OOP model — ref object, inheritance with of, method dispatch vs proc
#   nim c -r oop.nim

import std/strformat

# ── ref object: reference semantics (heap-allocated, GC-managed) ────────

type
  Animal = ref object of RootObj
    name: string

proc newAnimal(name: string): Animal =
  Animal(name: name)

let a = newAnimal("Generic Animal")
echo "Created: ", a.name

# ── Inheritance with `of` ───────────────────────────────────────────────

type
  Dog = ref object of Animal
    breed: string

  Cat = ref object of Animal
    color: string

proc newDog(name, breed: string): Dog =
  Dog(name: name, breed: breed)

proc newCat(name, color: string): Cat =
  Cat(name: name, color: color)

let buddy = newDog("Buddy", "Golden Retriever")
let whiskers = newCat("Whiskers", "Orange")

echo buddy.name, " is a ", buddy.breed
echo whiskers.name, " is ", whiskers.color

# ── method dispatch (dynamic) vs proc (static) ──────────────────────────

# method — dispatches based on the runtime type (virtual dispatch)
method speak(a: Animal): string {.base.} =
  "Some animal sound"

method speak(d: Dog): string =
  "Woof! I'm a " & d.breed & " called " & d.name

method speak(c: Cat): string =
  "Meow! I'm a " & c.color & " cat named " & c.name

# proc — dispatches based on the compile-time type (static dispatch)
proc describe(a: Animal): string =
  "Animal: " & a.name

proc describe(d: Dog): string =
  "Dog: " & d.name & " (" & d.breed & ")"

# ── Dynamic dispatch in action ──────────────────────────────────────────

let animals: seq[Animal] = @[buddy, whiskers]

echo "\n── Method dispatch (dynamic) ──"
for pet in animals:
  echo "  ", pet.speak()  # calls the correct method at runtime

echo "\n── Proc dispatch (static) ──"
for pet in animals:
  echo "  ", pet.describe()  # always calls Animal.describe (no virtual dispatch)

echo "\nDirect calls (known type at compile time):"
echo "  ", buddy.describe()
echo "  ", whiskers.describe()

# ── of operator: type check at runtime ──────────────────────────────────

echo "\n── Type checks with `of` ──"
for pet in animals:
  if pet of Dog:
    echo pet.name, " is a Dog"
  elif pet of Cat:
    echo pet.name, " is a Cat"