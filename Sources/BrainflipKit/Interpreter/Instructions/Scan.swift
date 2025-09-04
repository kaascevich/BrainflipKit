// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/scan(_:)`` instruction.
  ///
  /// - Parameter increment: The value to increment the cell pointer by on each
  ///   iteration.
  mutating func handleScanInstruction(_ increment: CellIndex) {
    while state.currentCellValue != 0 {
      state.cellPointer += increment
    }
  }
}
