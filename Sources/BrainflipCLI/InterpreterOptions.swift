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
      
      @Flag(
         name: [.customLong("wrap")],
         inversion: .prefixedNo,
         help: """
         Whether to allow cell values to wrap around when they overflow or \
         underflow.
         """
      ) var wraparound: Bool = true
      
      @Option(
         name: [.customLong("eoi"), .customLong("end-of-input")],
         help: .init(
            """
            The action to take on the current cell when an input instruction \
            is executed, but there are no characters remaining in the input \
            buffer.
            """,
            discussion: "No action is taken if this option is not specified.",
            valueName: "behavior"
         )
      ) var endOfInputBehavior: EndOfInputBehavior?
      
      @Option(
         name: [.customShort("x"), .customLong("extras"), .long],
         parsing: .upToNextOption,
         help: .init(
            "A list of optional, extra instructions to enable.",
            discussion: ExtraInstruction.allCases
               .map {
                  "(\($0.rawValue)) \(String(describing: $0)): \($0.details)"
               }
               .joined(separator: "\n"),
            valueName: "instructions"
         )
      ) var extraInstructions: [ExtraInstruction] = []
   }
}
