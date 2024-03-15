// InterpreterOptions.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

import ArgumentParser
import BrainflipKit

extension BrainflipCLI {
   struct InterpreterOptions: ParsableArguments {
      enum EndOfInputBehavior: String, CaseIterable, ExpressibleByArgument {
         case zero, max
         case error
      }
      
      @Option(
         name: [.customShort("s"), .long],
         help: .init(
            "The bit size to use for the cells. Must be less than \(Interpreter.Options.maxCellSize).",
            valueName: "size"
         )
      ) var cellSize: UInt8 = 8
      
      @Option(
         name: .long,
         help: .init("The total size of the cell array (also known as the tape).", valueName: "size")
      ) var tapeSize: Int = 30_000
      
      @Option(
         name: [.customLong("ptr-location"), .long],
         help: .init("The initial location of the cell pointer (0-indexed).", valueName: "location")
      ) var pointerLocation: Int = 0
      
      @Flag(
         name: .customLong("wrap"),
         inversion: .prefixedEnableDisable,
         help: "Whether to allow cell values to wrap around when they overflow or underflow."
      ) var wraparound: Bool = true
      
      @Option(
         name: [.customLong("eoi"), .customLong("end-of-input")],
         help: .init(
            "The action to take on the current cell when an input instruction is executed, but there are no characters remaining in the input buffer.",
            discussion: "No action is taken if this option is not specified.",
            valueName: "behavior"
         )
      ) var endOfInputBehavior: EndOfInputBehavior?
   }
}
