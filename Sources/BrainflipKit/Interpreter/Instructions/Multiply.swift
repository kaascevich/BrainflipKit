// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/multiply(_:)`` instruction.
  ///
  /// - Parameter multiplications: The multiplications to perform.
  @inlinable @inline(__always)
  mutating func handleMultiplyInstruction(
    _ multiplications: [CellOffset: CellValue],
    final: CellValue
  ) {
    for (offset, increment) in multiplications {
      state.tape[state.cellPointer &+ offset, default: 0] &+=
        state.currentCellValue &* increment
    }
    state.currentCellValue = final
  }
}
