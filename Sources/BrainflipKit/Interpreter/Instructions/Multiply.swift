// Multiply.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

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
    multiplyingBy factor: UInt32,
    storingAtOffset offset: Int
  ) throws(Self.Error) {
    let offsettedPointer = self.cellPointer + offset

    // MARK: Multiplying

    let (multiplyResult, multiplyOverflow) = self.currentCellValue
      .multipliedReportingOverflow(by: factor)

    if multiplyOverflow {
      guard options.allowCellWraparound else {
        throw Error.cellOverflow(position: self.cellPointer)
      }
    }

    // MARK: Adding
    
    let (additionResult, additionOverflow) = self.tape[
      offsettedPointer, default: 0
    ].addingReportingOverflow(multiplyResult)
    
    if additionOverflow {
      guard options.allowCellWraparound else {
        throw Error.cellOverflow(position: offsettedPointer)
      }
    }

    // MARK: Setting
    
    self.tape[offsettedPointer] = additionResult

    // as a side effect of the standard multiply loop, the
    // current cell is set to 0, so we need to replicate that
    // behavior here
    self.currentCellValue = 0
  }
}
