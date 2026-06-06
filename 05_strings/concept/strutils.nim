# strutils — string manipulation
#   import std/strutils

import std/strutils

# ── Case conversion ───────────────────────────────────────────────────

echo "hello".toUpperAscii()       # "HELLO"
echo "WORLD".toLowerAscii()       # "world"
echo "niM LanG".capitalizeAscii() # "Nim lang"


# ── Whitespace handling ───────────────────────────────────────────────

echo "  hello  ".strip()          # "hello"
echo "a,b, c".strip(chars = {'a', 'c'})  # ",b, "
echo "a  b   c".normalize()       # "a b c" — single spaces


# ── Padding and alignment ─────────────────────────────────────────────

echo "42".alignLeft(6)            # "42    "
echo "42".align(6)                # "    42" (right)
echo "42".center(6)               # "  42  "
echo "42".center(6, '-')          # "--42--"


# ── Splitting ─────────────────────────────────────────────────────────

echo "a,b,c".split(',')           # @["a", "b", "c"]
echo "a,b,c".rsplit(',', maxsplit = 1)  # @["a,b", "c"]
echo "a,,c".split(',')            # @["a", "", "c"]
echo "".split(',')                # @[""]

# Split into lines
let text = "line1\nline2\nline3"
echo text.splitLines()            # @["line1", "line2", "line3"]


# ── Joining ───────────────────────────────────────────────────────────

echo ["a", "b", "c"].join(", ")   # "a, b, c"
echo ["one"].join(" | ")          # "one"


# ── Finding ───────────────────────────────────────────────────────────

echo "hello world".find('o')      # 4
echo "hello world".rfind('o')     # 7
echo "hello world".find("world")  # 6
echo "x".find('y')                # -1


# ── startsWith, endsWith, contains ────────────────────────────────────

echo "debug=true".contains('=')   # true
echo "file.nim".endsWith(".nim")  # true
echo "## comment".startsWith("##")  # true
echo "hello".contains("ell")      # true


# ── Replacing ─────────────────────────────────────────────────────────

echo "I like cats".replace("cats", "dogs")  # "I like dogs"
echo "a-b-c".replace('-', '_')              # "a_b_c"
echo "hello".replace("l", "LL")  # "heLLLo" — replaces all
echo "hello".replaceWord("he", "ha")        # "hello" — whole word

# count-limited replace (Nim 2.2+ syntax may vary):
# echo "hello".replace("l", "LL", 1)  # "heLLlo"


# ── Validations: these check character properties ────────────────────
# In Nim 2.2+, some validators may need explicit import or work as UFCS only:
# echo "123".isDigit           # Check with nim check on your version
# echo "abc".isAlphaAscii
# echo "abc123".isAlphaNumeric


# ── Parsing numbers ───────────────────────────────────────────────────

echo parseInt("42")               # 42
echo parseFloat("3.14")           # 3.14
echo parseHexInt("FF")            # 255


# ── Multi-replace ─────────────────────────────────────────────────────

echo "abc".multiReplace(("a", "1"), ("b", "2"), ("c", "3"))  # "123"


# ── Count ─────────────────────────────────────────────────────────────

echo "banana".count('a')          # 3
echo "ababab".count("ab")         # 3


# ── repeat ────────────────────────────────────────────────────────────

echo "na".repeat(4) & " Batman!"  # "nananana Batman!"


# ── Indentation ───────────────────────────────────────────────────────

let code = "line1\nline2\nline3"
echo code.indent(4)               # "    line1\n    line2\n    line3"