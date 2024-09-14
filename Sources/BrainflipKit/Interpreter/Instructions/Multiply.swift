// Multiply.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes an ``Instruction/multiply(_:)`` instruction.
  mutating func handleMultiplyInstruction(
    multiplyingBy factor: UInt32,
    storingAtOffset offset: Int
  ) throws {
    let multiplicationResult = self.currentCellValue
      .multipliedReportingOverflow(by: factor)
    
    let additionResult = self.tape[self.cellPointer + offset, default: 0]
      .addingReportingOverflow(multiplicationResult.partialValue)
    
    // check for wraparound
    if multiplicationResult.overflow || additionResult.overflow {
      // check whether it's allowed
      guard options.allowCellWraparound else {
        throw Error.cellOverflow(position: self.cellPointer)
      }
    }
    
    self.tape[self.cellPointer + offset] = additionResult.partialValue
    self.currentCellValue = 0
  }
}
