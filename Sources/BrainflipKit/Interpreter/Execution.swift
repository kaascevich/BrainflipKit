// Execution.swift
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
   /// Executes the instructions stored in ``Interpreter/program``.
   ///
   /// - Returns: The program's output.
   ///
   /// - Throws: An interpreter ``Error`` if an issue was
   ///   encountered during execution.
   public func run() async throws -> String {
      resetState()
            
      for instruction in program {
         try await handleInstruction(instruction)
      }
      
      return self.outputBuffer
   }
   
   /// Executes an individual ``Instruction``.
   ///
   /// - Parameter instruction: The instruction to execute.
   ///
   /// - Throws: An interpreter ``Error`` if an issue was
   ///   encountered during execution.
   internal func handleInstruction(_ instruction: Instruction) async throws {
      switch instruction {
      case .increment: try handleIncrementInstruction()
      case .decrement: try handleDecrementInstruction()
         
      case .nextCell: handleNextCellInstruction()
      case .prevCell: handlePrevCellInstruction()
      
      case .loop(let instructions): try await handleLoop(instructions)
         
      case .output: handleOutputInstruction()
      case .input: try handleInputInstruction()
      }
   }
}
