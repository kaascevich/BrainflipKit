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
  mutating func handleAddInstruction(_ value: CellValue) throws {
    let (result, overflow) =
    state.currentCellValue.addingReportingOverflow(value)

    if !options.allowCellWraparound && overflow {
      throw if value < 0 {
        InterpreterError.cellUnderflow(position: state.cellPointer)
      } else {
        InterpreterError.cellOverflow(position: state.cellPointer)
      }
    }

    state.currentCellValue = result
  }
}
