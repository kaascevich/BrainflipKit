// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

import Parsing
typealias ParserProtocol = Parsing.Parser

extension Program {
  /// A parser that parses a program.
  struct Parser: ParserProtocol {
    /// Whether to optimize the parsed program.
    let optimizations: Bool

    /// A parser that parses a single instruction.
    private struct InstructionParser: ParserProtocol {
      /// Whether to optimize the parsed program.
      let optimizations: Bool

      var body: some ParserProtocol<Substring, Instruction> {
        OneOf {
          // MARK: Simple

          "+".map { Instruction.add(+1) }
          "-".map { Instruction.add(-1) }

          ">".map { Instruction.move(+1) }
          "<".map { Instruction.move(-1) }

          ",".map { Instruction.input }
          ".".map { Instruction.output }

          // MARK: Extras

          First()
            .map(.representing(ExtraInstruction.self))
            .map(Instruction.extra)

          // MARK: Loops

          Parse(Instruction.loop) {
            "["
            Program.Parser(optimizations: optimizations)
            "]"
          }
        }
      }
    }

    var body: some ParserProtocol<Substring, Program> {
      let programParser = Many {
        InstructionParser(optimizations: optimizations)
      }

      if optimizations {
        programParser.map(Optimizer.optimizingWithoutNesting)
      } else {
        programParser
      }
    }
  }
}
