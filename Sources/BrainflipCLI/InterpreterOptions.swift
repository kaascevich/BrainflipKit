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
      @Option(
         name: [.customShort("s"), .long],
         help: .init(
            "The bit size to use for the cells. Must be one of 8, 16, or 32.",
            discussion: "This also affects the encoding used for input and output; 8-bit cells will use UTF-8, 16-bit cells will use UTF-16, and 32-bit cells will use UTF-32.",
            valueName: "size"
         )
      ) var cellSize: Int = 8
      
      @Option(
         name: .long,
         help: .init("The total size of the cell array.", valueName: "size")
      ) var arraySize: Int = 30_000
      
      @Option(
         name: .long,
         help: .init("The initial location of the cell pointer (0-indexed).", valueName: "location")
      ) var pointerLocation: Int = 0
      
      @Flag(
         name: .long,
         inversion: .prefixedNo,
         help: "Whether to allow cell values to wrap around when they overflow or underflow."
      ) var wraparound: Bool = true
   }
}
