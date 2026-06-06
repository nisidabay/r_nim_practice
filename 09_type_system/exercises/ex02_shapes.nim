# Exercise 2: Shape Calculator
type
  ShapeKind = enum skCircle, skRect
  Shape = object
    case kind: ShapeKind
    of skCircle: radius: float
    of skRect: width, height: float

proc area(s: Shape): float =
  case s.kind
  of skCircle: 3.14159 * s.radius * s.radius
  of skRect: s.width * s.height

echo Shape(kind: skCircle, radius: 5).area()
echo Shape(kind: skRect, width: 4, height: 3).area()
