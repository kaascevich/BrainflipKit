// IncDec.swift
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
   /// Executes an ``Instruction/increment(_:)`` instruction.
   func handleIncrementInstruction() throws {
      if state.currentCellValue == options.cellMax { // wraparound
         guard options.allowCellWraparound else { throw Error.cellOverflow }
         state.currentCellValue = 0
      } else {
         state.currentCellValue += 1
      }
   }
   
   /// Executes a ``Instruction/decrement(_:)`` instruction.
   func handleDecrementInstruction() throws {
      if state.currentCellValue == 0 { // wraparound
         guard options.allowCellWraparound else { throw Error.cellUnderflow }
         state.currentCellValue = options.cellMax
      } else {
         state.currentCellValue -= 1
      }
   }
}
