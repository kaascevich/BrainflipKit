// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes a ``Instruction/loop(_:)``.
  ///
  /// - Parameter instructions: The instructions to loop over.
  ///
  /// - Throws: An ``InterpreterError`` if an error occurs while executing the
  ///   instructions.
  @inline(__always)
  mutating func handleLoop(_ instructions: [Instruction]) throws {
    while state.currentCellValue != 0 {
      for instruction in instructions {
        try handleInstruction(instruction)
      }
    }
  }
}
