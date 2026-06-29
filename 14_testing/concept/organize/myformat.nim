# Module: myformat — string formatting utilities

import std/strutils

proc padCenter*(s: string, width: int): string =
  ## Center s in a field of `width` characters. Wider strings are truncated.
  let pad = width - s.len
  if pad <= 0: return s
  let leftPad = pad div 2
  let rightPad = pad - leftPad
  result = spaces(leftPad) & s & spaces(rightPad)

proc truncateLeft*(s: string, maxLen: int): string =
  ## Keep last maxLen chars, prefix with "…" if truncated.
  if s.len <= maxLen:
    s
  else:
    "…" & s[s.len - maxLen .. ^1]
