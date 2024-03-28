// Add.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

internal extension Interpreter {
   /// Executes an ``Instruction/add(_:)`` instruction.
   mutating func handleAddInstruction(_ value: Int32) throws {
      let twosComplementValue = CellValue(bitPattern: value)
      
      let overflowCheck = if value < 0 {
         self.currentCellValue.subtractingReportingOverflow
      } else {
         self.currentCellValue.addingReportingOverflow
      }
      
      if overflowCheck(twosComplementValue).overflow { // wraparound
         guard options.allowCellWraparound else {
            let errorType = if value < 0 { Error.cellUnderflow } else { Error.cellOverflow }
            throw errorType(self.cellPointer)
         }
      }
      self.currentCellValue &+= twosComplementValue
   }
}
