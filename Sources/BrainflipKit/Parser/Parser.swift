// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

internal import Parsing

/// A parser that parses a single instruction.
private struct InstructionParser: Parser {
  var body: some Parser<Substring, Instruction> {
    OneOf {
      Many(1..., into: 0, +=) {
        OneOf {
          "+".map { +1 }
          "-".map { -1 }
        }
      }.map(Instruction.add)

      Many(1..., into: 0, +=) {
        OneOf {
          ">".map { +1 }
          "<".map { -1 }
        }
      }.map(Instruction.move)

      ",".map { Instruction.input }
      ".".map { Instruction.output }

      Parse(Instruction.loop) {
        "["
        ProgramParser()
        "]"
      }
    }
  }
}

/// A parser that parses a program.
struct ProgramParser: Parser {
  var body: some Parser<Substring, [Instruction]> {
    Many {
      InstructionParser()
    }
  }
}
