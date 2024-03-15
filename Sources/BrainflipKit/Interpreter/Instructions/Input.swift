// Input.swift
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
   /// Executes an ``Instruction/input`` instruction.
   func handleInputInstruction() throws {
      // make sure we've actually got some input to work with
      guard let nextInputCharacter = self.inputBuffer.first else {
         switch options.endOfInputBehavior {
         case nil: break
         case .setTo(let value): self.currentCellValue = value
         case .throwError: throw Error.endOfInput
         }
         
         return
      }
      
      self.inputBuffer.removeFirst() // we deal with one character at a time
      
      let characterValue = nextInputCharacter.unicodeScalars.first!.value
      assert(characterValue < options.cellMax)
      self.currentCellValue = CellValue(characterValue)
   }
}
