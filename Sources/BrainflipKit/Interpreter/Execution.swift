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
   /// - Returns: A tuple containing the program's output and
   ///   the final state of the interpreter.
   ///
   /// - Throws: An interpreter ``Error`` if an issue was
   ///   encountered during execution.
   public consuming func runReturningFinalState() async throws -> State {
      for instruction in program {
         try await handleInstruction(instruction)
      }
      
      return state
   }
   
   /// Executes the instructions stored in ``Interpreter/program``.
   ///
   /// - Returns: The program's output.
   ///
   /// - Throws: An interpreter ``Error`` if an issue was
   ///   encountered during execution.
   public consuming func run() async throws -> String {
      let finalState = try await self.runReturningFinalState()
      return finalState.outputBuffer
   }
   
   /// Executes an individual ``Instruction``.
   ///
   /// - Parameter instruction: The instruction to execute.
   ///
   /// - Throws: An interpreter ``Error`` if an issue was
   ///   encountered during execution.
   internal mutating func handleInstruction(_ instruction: Instruction) async throws {
      switch instruction {
      // MARK: Core
      
      case .add(let count): try handleAddInstruction(count)
         
      case .move(let count): handleMoveInstruction(count)
      
      case .loop(let instructions): try await handleLoop(instructions)
         
      case .output: handleOutputInstruction()
      case .input: try handleInputInstruction()
         
      // MARK: Non-core
         
      case .setTo(let value): handleSetToInstruction(value)
         
      case .scanLeft:  handleScanLeftInstruction()
      case .scanRight: handleScanRightInstruction()
         
      case .extra(let instruction): try await handleExtraInstruction(instruction)
      }
   }
}
