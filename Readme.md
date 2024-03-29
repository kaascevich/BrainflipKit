# BrainflipKit
An overly-underengineered brainf\*\*k interpreter in Swift

## Overview

BrainflipKit is a Swift package that interprets brainf\*\*k programs. 

If you're here, then chances are you already know what brainf\*\*k is (if not, [here's a quick and dirty reference](http://brainfuck.org/brainfuck.html)). So instead of dwelling on the basics, I'll go over what makes this interpreter *marginally* unique.

 - Full Unicode support. That's just what happens when you're using Swift.
 - The cells are 32-bit instead of 8-bit, due to the aforementioned Unicode support. Most well-written brainf\*\*k programs shouldn't be heavily affected by this.
 - The tape is infinite in both directions.
 - The end-of input behavior is customizable -- you can ignore EOI, set the cell to 0, set the cell to its maximum, or throw an error. (Why you'd throw an error on EOI, I don't know, but the option is there for the taking.)
 - Cell wrapping can be disabled (by throwing an error).
 - Some relatively minor optimizations are performed, including:
   - Condensing repeated instructions
   - Merging `+-` and `<>` instructions
   - Replacing `[-]` with a dedicated cell-clear instruction
   - Replacing copy loops and multiplication loops with a dedicated instruction
 - There are some extra instructions that can be enabled if you wish.
