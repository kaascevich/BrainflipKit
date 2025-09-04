// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

/// A list of instructions to be executed by an ``Interpreter``.
public struct Program: Equatable, Hashable, Sendable {
  /// The instructions that make up this program.
  var instructions: [Instruction]

  /// Creates a program from a list of instructions.
  ///
  /// - Parameter instructions: A list of instructions.
  init(_ instructions: [Instruction]) {
    self.instructions = instructions
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
  /// ### Clear Loops
  /// The `[-]` construct is replaced with a `setTo(0)` instruction. If an `add`
  /// instruction follows a `setTo(0)` instruction, the value of the `add`
  /// instruction is used in the `setTo` instruction instead of 0.
  ///
  /// ### Scan Loops
  /// A `loop` instruction containing only `move` instructions  is replaced with
  /// a `scan` instruction.
  ///
  /// ### Dead Code
  /// Loops that occur immediately after other loops are removed.
  ///
  /// This can be done because, immediately after a loop finishes, the current
  /// cell's value is always 0 (because that's the end condition for a loop);
  /// therefore, an immediately following loop will never be entered.
  ///
  /// ### Multiply Loops
  ///
  /// This replaces constructs of the following form with equivalent
  /// `multiply(factor, offset)` instructions.
  ///
  /// ```
  /// loop {
  ///   add(-1)
  ///   move(offset)
  ///   add(factor)
  ///   move(-offset)
  /// }
  /// ```
  ///
  /// For example, `[-<<<++>>>]` would be reduced to
  /// `multiply(factor: 2, offset: -3)`.
  ///
  /// - Parameters:
  ///   - source: The original source code for a Brainflip program.
  ///
  /// - Throws: An `Error` if `source` is not a valid program (that is, if it
  ///   contains unmatched brackets).
  public init(_ source: String) throws {
    self.instructions = try ProgramParser()
      .parse(source.filter(Instruction.validInstructions.contains))

    optimize()
  }
}

// MARK: Debugging

extension Program: CustomReflectable {
  public var customMirror: Mirror {
    Mirror(reflecting: instructions)
  }
}
