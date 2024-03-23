// PointerMovement.swift
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

extension Interpreter {
   private func advanceCellPointer(by offset: [CellValue].Index) throws {
      self.cellPointer += offset
      
      // ensure that we're still in the tape
      guard self.tape.indices.contains(self.cellPointer) else {
         throw Error.cellPointerOutOfBounds
      }
   }
   
   /// Executes a ``Instruction/nextCell(_:)`` instruction.
   internal func handleNextCellInstruction() throws {
      try advanceCellPointer(by: 1)
   }
   
   /// Executes a ``Instruction/prevCell(_:)`` instruction.
   internal func handlePrevCellInstruction() throws {
      try advanceCellPointer(by: -1)
   }
}
