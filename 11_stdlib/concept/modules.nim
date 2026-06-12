# Modules — import, include, and export mechanics
#   nim c -r concept/modules.nim
#
# Nim modules are files. Each file is its own module. Symbols are private
# by default — add `*` to export them.

# ── import: bring in symbols from another module ────────────────────────
#
# `import helper` makes helper.nim's exported symbols available here.

import helper
echo helper.greet("Nim")                    # "Hello, Nim!"
echo greet("UFCS style")                    # also works (UFCS)

# ── import vs include ───────────────────────────────────────────────────
#
# `import` — pulls in exported symbols only; the module is compiled separately.
# `include` — pastes the file contents as if typed here; all symbols available.
#
# include is rare — used mainly for compile-time code splitting or templates.

# include helper  # would cause "redefinition of greet" — already imported above

# ── export marker ───────────────────────────────────────────────────────
#
# A module can re-export another module. This is useful for facade patterns:
#
#   module_a.nim:
#     proc foo*() = echo "foo"
#
#   module_b.nim:
#     import module_a
#     export module_a          # re-exports all of module_a's symbols
#
# Then `import module_b` also makes `foo()` available.

echo "Modules demo complete."