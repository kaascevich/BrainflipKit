// Add.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes an ``Instruction/add(_:)`` instruction.
  mutating func handleAddInstruction(_ value: Int32) throws(Self.Error) {
    let (overflowCheck, errorType) = if value < 0 {
      (self.currentCellValue.subtractingReportingOverflow, Error.cellUnderflow)
    } else {
      (self.currentCellValue.addingReportingOverflow, Error.cellOverflow)
    }
    
    let twosComplementValue = CellValue(bitPattern: value)
    
    // check for wraparound
    if overflowCheck(twosComplementValue).overflow {
      // check whether it's allowed
      guard options.allowCellWraparound else {
        throw errorType(self.cellPointer)
      }
    }
    
    self.currentCellValue &+= twosComplementValue
  }
}
