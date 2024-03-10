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

internal extension Interpreter {
   private func advanceCellPointer(by offset: CellArray.Index) throws {
      state.cellPointer = state.cellPointer.advanced(by: offset)
      
      // ensure that we're still in the array
      guard state.cells.indices.contains(state.cellPointer)
      else { throw Error.cellPointerOutOfBounds }
   }
   
   /// Executes a ``Instruction/nextCell(_:)`` instruction.
   func handleNextCellInstruction() throws {
      try advanceCellPointer(by: 1)
   }
   
   /// Executes a ``Instruction/prevCell(_:)`` instruction.
   func handlePrevCellInstruction() throws {
      try advanceCellPointer(by: -1)
   }
}
