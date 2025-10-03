// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

/// A list of instructions to be executed by an ``Interpreter``.
public struct Program: Equatable, Hashable, Codable, Sendable {
  /// The instructions that make up this program.
  var instructions: [Instruction]

  /// Creates a program from a list of instructions.
  ///
  /// - Parameter instructions: A list of instructions.
  init(_ instructions: [Instruction]) {
    self.instructions = instructions
  }
}

// MARK: Debugging

extension Program: CustomReflectable {
  /// The custom mirror for this instance.
  public var customMirror: Mirror {
    Mirror(reflecting: instructions)
  }
}
