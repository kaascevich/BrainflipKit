// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/setTo(_:)`` instruction.
  ///
  /// - Parameter value: The value to set the current cell to.
  mutating func handleSetToInstruction(_ value: CellValue) {
    self.currentCellValue = value
  }
}
