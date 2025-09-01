// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/multiply(_:)`` instruction.
  ///
  /// - Parameters:
  ///   - factor: The factor to multiply the current cell by.
  ///   - offset: The offset from the current cell to store the result.
  ///
  /// - Throws: ``InterpreterError/cellOverflow`` if an overflow occurs and
  ///   ``InterpreterOptions/allowCellWraparound`` is `false`.
  mutating func handleMultiplyInstruction(
    multiplyingBy factor: CellValue,
    storingAtOffset offset: CellPointer
  ) throws(InterpreterError) {
    let offsettedPointer = self.cellPointer + offset

    // MARK: Multiplying

    let (multiplyResult, multiplyOverflow) = self.currentCellValue
      .multipliedReportingOverflow(by: factor)

    if multiplyOverflow && !options.allowCellWraparound {
      throw .cellOverflow(position: self.cellPointer)
    }

    // MARK: Adding

    let (additionResult, additionOverflow) = self.tape[
      offsettedPointer,
      default: 0
    ].addingReportingOverflow(multiplyResult)

    if additionOverflow && !options.allowCellWraparound {
      throw .cellOverflow(position: offsettedPointer)
    }

    // MARK: Setting

    self.tape[offsettedPointer] = additionResult

    // as a side effect of the standard multiply loop, the current cell is set
    // to 0, so we need to replicate that behavior here
    self.currentCellValue = 0
  }
}
