// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

private import Parsing

/// A parser that parses a single instruction.
private struct InstructionParser: Parser {
  var body: some Parser<Substring, Instruction> {
    OneOf {
      Many(1..., into: 0, &+=) {
        OneOf {
          "+".map { +1 }
          "-".map { -1 }
        }
      }.map(Instruction.add)

      Many(1..., into: 0, &+=) {
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
private struct ProgramParser: Parser {
  var body: some Parser<Substring, [Instruction]> {
    Many {
      InstructionParser()
    }
  }
}

extension Program {
  /// Parses the given string into a `Program` instance.
  ///
  /// The following mappings are used to convert a `Character` into an
  /// ``Instruction``:
  ///
  /// | Character |       Instruction        |
  /// |-----------|--------------------------|
  /// |  `+` `-`  | ``Instruction/add(_:)``  |
  /// |  `<` `>`  | ``Instruction/move(_:)`` |
  /// |  `[` `]`  | ``Instruction/loop(_:)`` |
  /// |    `.`    | ``Instruction/output``   |
  /// |    `,`    | ``Instruction/input``    |
  ///
  /// All other characters are ignored.
  ///
  /// ## Optimizations
  ///
  /// Some constructs can be simplified to speed up program execution.
  ///
  /// ### Adjacent Instructions
  /// Repeated occurrences of `+` and `-` are condensed into a single
  /// instruction, as are `>` and `<`. Additionally, instructions that cancel
  /// each other out (such as `+-` or `><`) are removed.
  ///
  /// ### Instructions With No Effect
  /// Instructions that do not have any effect (such as `add` or `move`
  /// instructions with a value of `0`) are removed.
  ///
  /// ### Dead Code
  /// Loops that occur immediately after other loops are removed.
  ///
  /// This can be done because, immediately after a loop finishes, the current
  /// cell's value is always 0 (because that's the end condition for a loop);
  /// therefore, an immediately following loop will never be entered.
  ///
  /// - Parameters:
  ///   - source: The original source code for a Brainflip program.
  ///
  /// - Throws: An `Error` if `source` is not a valid program (that is, if it
  ///   contains unmatched brackets).
  public init(_ source: String) throws {
    let validInstructions: [Character] = [
      "+", "-", ">", "<", "[", "]", ",", ".",
    ]
    let filteredSource = source.filter(validInstructions.contains)

    self.instructions = try ProgramParser().parse(filteredSource)
    optimize()
  }
}
