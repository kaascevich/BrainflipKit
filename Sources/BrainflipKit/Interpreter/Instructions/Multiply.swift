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
    factor: CellValue,
    offset: CellIndex
  ) throws {
    let offsettedPointer = state.cellPointer + offset

    // MARK: Multiplying

    let (multiplyResult, multiplyOverflow) = state.currentCellValue
      .multipliedReportingOverflow(by: factor)

    if !options.allowCellWraparound && multiplyOverflow {
      throw InterpreterError.cellOverflow(position: state.cellPointer)
    }

    // MARK: Adding

    let (additionResult, additionOverflow) = state.tape[
      offsettedPointer,
      default: 0
    ].addingReportingOverflow(multiplyResult)

    if !options.allowCellWraparound && additionOverflow {
      throw InterpreterError.cellOverflow(position: offsettedPointer)
    }

    // MARK: Setting

    state.tape[offsettedPointer] = additionResult

    // as a side effect of the standard multiply loop, the current cell is set
    // to 0, so we need to replicate that behavior here
    state.currentCellValue = 0
  }
}
