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
      while state.instructionPointerIsValid {
         try handleInstruction(state.currentInstruction)
         state.instructionPointer += 1 // point to the next instruction
      }
      
      return state.outputString
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
      
      /// Executes an ``Instruction/increment(_:)`` instruction.
      func handleIncrementInstruction() throws {
         if state.currentCellValue == CellValue.max { // wraparound
            guard options.allowCellWraparound else {
               throw Interpreter.Error.cellOverflow
            }
            state.currentCellValue = CellValue.min
         } else {
            state.currentCellValue += 1
         }
      }
      
      /// Executes a ``Instruction/decrement(_:)`` instruction.
      func handleDecrementInstruction() throws {
         if state.currentCellValue == CellValue.min { // wraparound
            guard options.allowCellWraparound else {
               throw Interpreter.Error.cellUnderflow
            }
            state.currentCellValue = CellValue.max
         } else {
            state.currentCellValue -= 1
         }
      }
      
      /// Executes a ``Instruction/nextCell(_:)`` instruction.
      func handleNextCellInstruction() throws {
         state.cellPointer += 1
         guard state.cells.indices.contains(state.cellPointer) else {
            throw Error.cellPointerOutOfBounds
         }
      }
      /// Executes a ``Instruction/prevCell(_:)`` instruction.
      func handlePrevCellInstruction() throws {
         state.cellPointer -= 1
         guard state.cells.indices.contains(state.cellPointer) else {
            throw Error.cellPointerOutOfBounds
         }
      }
      
      /// Executes a ``Instruction/loop(_:)``.
      ///
      /// - Parameter instructions: The instructions to loop over.
      func handleLoop(_ instructions: [Instruction]) throws {
         while state.currentCellValue != 0 {
            for instruction in instructions {
               try handleInstruction(instruction)
            }
         }
      }
      
      /// Executes an ``Instruction/output`` instruction.
      func handleOutputInstruction() {
         state.output.append(state.currentCellValue)
      }
      
      /// Executes an ``Instruction/input`` instruction.
      func handleInputInstruction() {
         // make sure we've actually got some input to work with
         guard let nextInputCharacter = state.input.first else {
            state.currentCellValue = 0 // null out the cell
            return
         }
         state.input.removeFirst() // we deal with one character at a time
         
         // we should be OK to force-unwrap, since input was validated
         // before execution
         state.currentCellValue = nextInputCharacter
      }
   }
}
