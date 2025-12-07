# BrainflipKit
An overly-underengineered brainfuck interpreter in Swift

## Overview

BrainflipKit is a Swift command-line app that interprets brainfuck programs.

If you're here, then chances are you already know what brainfuck is (if not,
[here's a quick and dirty reference](http://brainfuck.org/brainfuck.html)). So
instead of dwelling on the basics, I'll go over what makes this interpreter
_marginally_ unique.

- Full Unicode support. That's just what happens when you're using Swift.
- The cells are 64-bit instead of 8-bit, due to the aforementioned Unicode
  support. Most well-written brainfuck programs shouldn't be heavily affected by
  this.
- The tape is infinite in both directions.
- The end-of-input behavior is customizable -- you can ignore EOI, set the
  cell to 0, or set the cell to its maximum.
- Some relatively basic optimizations are performed, including:
  - Condensing repeated instructions
  - Merging `+`/`-` and `<`/`>` instructions (and removing pairs that cancel
    each other out)
  - Replacing multiplication loops with a dedicated instruction
