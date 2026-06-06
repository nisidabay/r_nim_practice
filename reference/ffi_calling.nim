# Call C functions directly from Nim. No bindings, no wrappers.
# The call compiles to the same machine code as if you wrote C.
# Nim IS a C compiler — FFI is not a bridge, it's the same road.

# ── Basic: declare, then call. `varargs` enables printf-style format ──

proc printf(format: cstring): cint
  {.importc: "printf", header: "<stdio.h>", varargs.}
discard printf("Hello from C via printf! Value: %d\n", 42)


# ── Renaming: Nim symbol ≠ C symbol ───────────────────────────────────

proc shout(s: cstring): cint
  {.importc: "puts", header: "<stdio.h>".}
discard shout("This calls C's puts() but we call it shout() in Nim")


# ── Calling math functions from libm ──────────────────────────────────
# Build: nim c -r --passL:"-lm" ffi_calling.nim

proc c_sqrt(x: cdouble): cdouble {.importc: "sqrt", header: "<math.h>".}
echo "sqrt(64) = ", c_sqrt(64.0)


# ── Shell commands via C's system() ───────────────────────────────────

proc c_system(command: cstring): cint
  {.importc: "system", header: "<stdlib.h>".}

echo "Exit code: ", c_system("echo 'Called from Nim via C'")


# ── Opaque C structs: FILE* example ───────────────────────────────────

type
  FILE {.importc: "FILE", header: "<stdio.h>".} = object

proc fopen(filename: cstring, mode: cstring): ptr FILE
  {.importc: "fopen", header: "<stdio.h>".}
proc fclose(stream: ptr FILE): cint
  {.importc: "fclose", header: "<stdio.h>".}

let f = fopen("ffi_calling.nim", "r")
if f != nil:
  echo "Opened via C's fopen"
  discard fclose(f)


# ── Why Nim FFI beats everyone ────────────────────────────────────────
# Python ctypes: runtime loading, marshalling, 2-10x overhead
# Rust FFI: unsafe blocks, manual CString, complex bindgen  
# Nim: declare → call. Compiles to a direct C call. Zero cost.
