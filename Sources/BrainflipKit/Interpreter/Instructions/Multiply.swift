// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

extension Interpreter {
  /// Executes an ``Instruction/multiply(_:)`` instruction.
  ///
  /// - Parameters:
  ///   - factor: The factor to multiply the current cell by.
  ///   - offset: The offset from the current cell to store the result.
  ///
  /// - Throws: ``Error/cellOverflow`` if an overflow occurs and
  ///   ``Interpreter/Options/allowCellWraparound`` is `false`.
  mutating func handleMultiplyInstruction(
    multiplyingBy factor: CellValue,
    storingAtOffset offset: Int,
  ) throws(InterpreterError) {
    let offsettedPointer = self.cellPointer + offset

    // MARK: Multiplying

    let (multiplyResult, multiplyOverflow) = self.currentCellValue
      .multipliedReportingOverflow(by: factor)

    if multiplyOverflow {
      guard options.allowCellWraparound else {
        throw .cellOverflow(position: self.cellPointer)
      }
    }

    // MARK: Adding

    let (additionResult, additionOverflow) = self.tape[offsettedPointer, default: 0]
      .addingReportingOverflow(multiplyResult)

    if additionOverflow {
      guard options.allowCellWraparound else {
        throw .cellOverflow(position: offsettedPointer)
      }
    }

    // MARK: Setting

    self.tape[offsettedPointer] = additionResult

    // as a side effect of the standard multiply loop, the current cell is set
    // to 0, so we need to replicate that behavior here
    self.currentCellValue = 0
  }
}
