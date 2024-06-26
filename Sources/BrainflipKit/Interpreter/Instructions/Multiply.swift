// Multiply.swift
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
