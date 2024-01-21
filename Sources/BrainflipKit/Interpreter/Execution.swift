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

import OSLog

public extension Interpreter {
   /// Executes the instructions stored in ``Interpreter/program``.
   ///
   /// - Parameter input: The input to pass to the program.
   ///   Defaults to an empty string.
   ///
   /// - Returns: The program's output.
   ///
   /// - Precondition: `input` contains only ASCII characters.
   /// - Precondition: All loops in the program are closed.
   @discardableResult func run(input: String = "") async throws -> String {
      resetState()
      
      Logger.interpreter.info(#"running program (input: "\#(input)")"#)
      self.input = input
      
      try await checkProgram()
      
      // while there's still code to execute
      while self.instructionPointerIsValid {
         try step()
      }
      
      Logger.interpreter.info(#"finished (output: "\#(self.output)")"#)
      return self.output
   }
   
   /// Executes the next instruction and increments
   /// ``Interpreter/State/instructionPointer``.
   func step() throws {
      guard self.instructionPointerIsValid else {
         // chances are someome tried to step past the last
         // instruction
         throw Error(logging: .noInstructionsRemaining)
      }
      
      try handleInstruction(self.currentInstruction)
      self.instructionPointer += 1 // point to the next instruction
   }
   
   /// Executes an individual ``Instruction``.
   ///
   /// - Parameter instruction: The instruction to execute.
   internal func handleInstruction(_ instruction: Instruction) throws {
      Logger.interpreter.debug("executing: \(String(describing: instruction))")
      
      switch instruction {
         // MARK: .increment
         case .increment:
            self.currentCellValue &+= 1 // wraparound
            Logger.interpreter.info("cell incremented @\(self.cellPointer) (new: \(self.currentCellValue))")
            
         // MARK: .decrement
         case .decrement:
            self.currentCellValue &-= 1 // wraparound
            Logger.interpreter.info("cell decremented @\(self.cellPointer) (new: \(self.currentCellValue))")
            
         // MARK: .nextCell
         case .nextCell:
            self.cellPointer += 1
            Logger.interpreter.info("moved cell pointer forward (new: \(self.cellPointer))")
            
         // MARK: .prevCell
         case .prevCell:
            self.cellPointer -= 1
            Logger.interpreter.info("moved cell pointer backward (new: \(self.cellPointer))")
            
         // MARK: Others
         case .loop(let boundType): try handleLoopInstruction(boundType)
            
         case .output: try handleOutputInstruction()
         case .input:  try handleInputInstruction()
      }
   }
   
   /// Executes a ``Instruction/loop(_:)`` instruction.
   ///
   /// - Parameter boundType: The bound type of this instruction.
   private func handleLoopInstruction(_ boundType: Instruction.LoopBound) throws {
      switch boundType {
         case .begin:
            self.stack.append(self.instructionPointer)
            Logger.interpreter.info("entering loop #\(self.nestingLevel)")
            
         case .end:
            if self.currentCellValue != 0 {
               Logger.interpreter.info("current cell is not 0 (actual: \(self.currentCellValue)), restarting loop #\(self.nestingLevel)")
               self.instructionPointer = self.stack.last! // set the IP to the beginning of the loop
            } else {
               Logger.interpreter.info("current cell is 0, exiting loop #\(self.nestingLevel)")
               // make sure we don't end up restarting a loop we're no longer in
               self.stack.removeLast()
            }
      }
   }
   
   /// Executes an ``Instruction/output`` instruction.
   private func handleOutputInstruction() throws {
      // nab the corresponding character from the ASCII code
      let newCharacter = Character(Unicode.Scalar(self.currentCellValue))
      self.output.append(newCharacter)
      Logger.interpreter.info("appended to output buffer: '\(newCharacter)'")
   }
   
   /// Executes an ``Instruction/input`` instruction.
   private func handleInputInstruction() throws {
      // make sure we've actually got some input to work with
      guard let nextInputCharacter = self.input.first else {
         Logger.interpreter.notice("nothing left in input buffer; setting current cell to 0")
         self.currentCellValue = 0 // null out the cell
         return
      }
      self.input.removeFirst() // we deal with one character at a time
      
      // make sure this character actually has a corresponding
      // ASCII value
      guard let asciiValue = nextInputCharacter.asciiValue else {
         throw Error(logging: .illegalCharacterInInput(nextInputCharacter))
      }
      
      self.currentCellValue = asciiValue
      Logger.interpreter.info("setting current cell to \(asciiValue) (from input: '\(nextInputCharacter)')")
   }
}
