// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes a ``Instruction/loop(_:)``.
  ///
  /// - Parameter instructions: The instructions to loop over.
  ///
  /// - Throws: An ``InterpreterError`` if an error occurs while executing the
  ///   instructions.
  mutating func handleLoop(
    _ instructions: Program
  ) throws(InterpreterError) {
    while self.currentCellValue != 0 {
      try execute(instructions)
    }
  }
}
