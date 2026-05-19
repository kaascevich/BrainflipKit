# BrainflipKit
an overly-underengineered brainfuck interpreter in Swift

## Overview

BrainflipKit is a Swift command-line app that interprets brainfuck programs.

if you're here, then chances are you already know what brainfuck is (if not,
[here's a quick and dirty reference](http://brainfuck.org/brainfuck.html)). so
instead of dwelling on the basics, I'll go over what makes this interpreter
_marginally_ unique.

- full Unicode support. that's just what happens when you use Swift
- the cells are 64-bit instead of 8-bit, due to the aforementioned Unicode
  support. most well-written brainfuck programs _shouldn't_ be heavily affected by
  this
- the tape is infinite in both directions
- the end-of-input behavior is customizable -- you can ignore EOI, set the
  cell to 0, or set the cell to its maximum
- some relatively basic optimizations are performed, including:
  - condensing repeated instructions
  - merging `+`/`-` and `<`/`>` instructions (and removing pairs that cancel
    each other out)
  - replacing multiplication loops with a dedicated instruction
