// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Parsing

/// A parser that parses a program.
struct ProgramParser: Parser {
  var body: some Parser<Substring, Program> {
    Many {
      OneOf {
        // MARK: Simple

        "+".map { Instruction.add(+1) }
        "-".map { Instruction.add(-1) }

        ">".map { Instruction.move(+1) }
        "<".map { Instruction.move(-1) }

        ",".map { Instruction.input }
        ".".map { Instruction.output }

        // MARK: Loops

        Parse(Instruction.loop) {
          "["
          ProgramParser()
          "]"
        }
      }
    }
  }
}
