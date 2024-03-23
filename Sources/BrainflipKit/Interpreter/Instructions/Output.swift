// Output.swift
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
   /// Executes an ``Instruction/output`` instruction.
   internal func handleOutputInstruction() {
      // if this cell's value doesn't correspond to a valid
      // Unicode character, do nothing
      guard
         let cellValueAsUInt32 = UInt32(exactly: self.currentCellValue),
         let unicodeScalar = Unicode.Scalar(cellValueAsUInt32)
      else { return }
      
      let character = Character(unicodeScalar)
      self.outputBuffer.append(character)
   }
}
