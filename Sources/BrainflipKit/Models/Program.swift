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

// MARK: Codable

extension Program: Codable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(contentsOf: instructions)
  }

  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    self.instructions = try container.decode([Instruction].self)
  }
}
