// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/add(_:)`` instruction.
  ///
  /// - Parameter value: The value to add to the current cell value.
  mutating func handleAddInstruction(_ value: CellValue) {
    state.currentCellValue &+= value
  }
}
