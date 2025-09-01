// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/add(_:)`` instruction.
  ///
  /// - Parameter value: The value to add to the current cell value.
  ///
  /// - Throws: ``InterpreterError/cellOverflow`` or
  ///   ``InterpreterError/cellUnderflow`` if an overflow/underflow occurs and
  ///   ``InterpreterOptions/allowCellWraparound`` is `false`.
  mutating func handleAddInstruction(_ value: CellValue) throws(InterpreterError) {
    let errorType =
      if value < 0 {
        InterpreterError.cellUnderflow
      } else {
        InterpreterError.cellOverflow
      }

    let (result, overflow) =
      self.currentCellValue.addingReportingOverflow(value)

    if overflow {
      guard options.allowCellWraparound else {
        throw errorType(self.cellPointer)
      }
    }

    self.currentCellValue = result
  }
}
