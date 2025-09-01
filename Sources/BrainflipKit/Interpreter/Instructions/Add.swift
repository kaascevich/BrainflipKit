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
  mutating func handleAddInstruction(
    _ value: CellValue
  ) throws(InterpreterError) {
    let (result, overflow) =
      self.currentCellValue.addingReportingOverflow(value)

    if overflow && !options.allowCellWraparound {
      throw if value < 0 {
        .cellUnderflow(position: self.cellPointer)
      } else {
        .cellOverflow(position: self.cellPointer)
      }
    }

    self.currentCellValue = result
  }
}
