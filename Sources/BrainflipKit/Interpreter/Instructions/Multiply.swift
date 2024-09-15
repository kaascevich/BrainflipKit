// Multiply.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
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
    let (multiplyResult, multiplyOverflow) = self.currentCellValue
      .multipliedReportingOverflow(by: factor)
    
    let (additionResult, additionOverflow) = self.tape[
      self.cellPointer + offset, default: 0
    ].addingReportingOverflow(multiplyResult)
    
    // check for wraparound
    if multiplyOverflow || additionOverflow {
      // check whether it's allowed
      guard options.allowCellWraparound else {
        throw Error.cellOverflow(position: self.cellPointer)
      }
    }
    
    self.tape[self.cellPointer + offset] = additionResult

    // as a side effect of the standard multiply loop, the
    // current cell is set to 0, so we need to replicate this
    // behavior here
    self.currentCellValue = 0
  }
}
