// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes a ``Instruction/move(_:)`` instruction.
  ///
  /// - Parameter count: The number of cells to move.
  @inline(__always)
  mutating func handleMoveInstruction(_ count: CellValue) {
    state.cellPointer &+= count
  }
}
