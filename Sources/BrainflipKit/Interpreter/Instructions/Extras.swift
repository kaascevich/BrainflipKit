// Extras.swift
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
   /// Executes the instruction contained within
   /// ``Instruction/extra(_:)``, if it is enabled.
   ///
   /// - Parameter instruction: The instruction to execute.
   mutating func handleExtraInstruction(_ instruction: ExtraInstruction) async throws {
      guard options.enabledExtraInstructions.contains(instruction) else {
         return
      }
      
      switch instruction {
      case .stop:
         throw Error.stopInstruction
         
      case .zero:
         self.currentCellValue = 0
      }
   }
}
