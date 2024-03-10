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

public extension Interpreter {
   /// Executes the instructions stored in ``Interpreter/program``.
   ///
   /// - Returns: The program's output.
   ///
   /// - Throws: An interpreter ``Error`` if an issue was encountered
   ///   during execution.
   @discardableResult func run() async throws -> String {
      resetState()
            
      // while there's still code to execute
      while program.indices.contains(state.instructionPointer) {
         try handleInstruction(program[state.instructionPointer])
         state.instructionPointer += 1 // point to the next instruction
      }
      
      return state.output
   }
   
   /// Executes an individual ``Instruction``.
   ///
   /// - Parameter instruction: The instruction to execute.
   ///
   /// - Throws: An interpreter ``Error`` if an issue was encountered
   ///   during execution.
   internal func handleInstruction(_ instruction: Instruction) throws {
      switch instruction {
      case .increment: try handleIncrementInstruction()
      case .decrement: try handleDecrementInstruction()
         
      case .nextCell: try handleNextCellInstruction()
      case .prevCell: try handlePrevCellInstruction()
      
      case .loop(let instructions): try handleLoop(instructions)
         
      case .output: handleOutputInstruction()
      case .input: handleInputInstruction()
      }
   }
}
