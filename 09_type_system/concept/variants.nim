# A value that is one of several known shapes. Exhaustive case checks
# are enforced at compile time — add a variant, the compiler screams
# until every case handles it.

type
  ValueKind = enum
    vkString, vkInteger, vkFloat

  ConfigValue = object
    case kind: ValueKind
    of vkString:  strVal: string
    of vkInteger: intVal: int
    of vkFloat:   floatVal: float

# ── Creating variants ─────────────────────────────────────────────────

let host = ConfigValue(kind: vkString, strVal: "localhost")
let port = ConfigValue(kind: vkInteger, intVal: 8080)
let timeout = ConfigValue(kind: vkFloat, floatVal: 2.5)

# ── Exhaustive matching: no `else` allowed ────────────────────────────

proc formatValue(v: ConfigValue): string =
  case v.kind
  of vkString:  v.strVal
  of vkInteger: $v.intVal
  of vkFloat:   $v.floatVal
  # Add a 4th variant to ValueKind → this won't compile until handled here

echo host.formatValue()      # "localhost"
echo port.formatValue()      # "8080"
echo timeout.formatValue()   # "2.5"


# ── Wrong field access is a compile-time error ────────────────────────

var val = ConfigValue(kind: vkString, strVal: "production")
# echo val.intVal   # compile ERROR — intVal doesn't exist on vkString
discard val


# ── Shared fields: declared OUTSIDE the case block ────────────────────

type
  HttpResult = object
    statusCode: int          # every variant has this
    case success: bool
    of true:  body: string
    of false: errorMessage: string

let ok = HttpResult(success: true, statusCode: 200, body: "{\"user\": \"carlos\"}")
let fail = HttpResult(success: false, statusCode: 404, errorMessage: "Not found")

echo ok.statusCode      # 200 — shared field, always accessible
echo fail.statusCode    # 404 — shared field works on any variant
# echo ok.errorMessage   # compile ERROR — ok variant has no errorMessage
