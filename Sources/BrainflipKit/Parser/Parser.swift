// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Parsing

/// A parser that parses a single instruction.
private struct InstructionParser: Parser {
  /// Whether to optimize the parsed program.
  let optimizations: Bool

  var body: some Parser<Substring, Instruction> {
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
        ProgramParser(optimizations: optimizations)
        "]"
      }
    }
  }
}

/// A parser that parses a program.
struct ProgramParser: Parser {
  /// Whether to optimize the parsed program.
  let optimizations: Bool

  var body: some Parser<Substring, Program> {
    let programParser = Many {
      InstructionParser(optimizations: optimizations)
    }

    if optimizations {
      programParser.map(Program.Optimizer.optimizingWithoutNesting)
    } else {
      programParser
    }
  }
}
