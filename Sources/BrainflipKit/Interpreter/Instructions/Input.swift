// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/input`` instruction.
  @inlinable @inline(__always)
  mutating func handleInputInstruction() {
    // make sure we actually have some input to work with
    guard let nextInputScalar = state.inputIterator.next() else {
      switch options.endOfInputBehavior {
      case .setTo(let value):
        state.currentCellValue = value
        return

      case nil:
        return
      }
    }

    state.currentCellValue = CellValue(nextInputScalar.value)
  }
}
