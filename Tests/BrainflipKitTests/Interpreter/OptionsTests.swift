// OptionsTests.swift
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

import Testing
@testable import class BrainflipKit.Interpreter

extension InterpreterTests {
   @Suite("Interpreter options")
   struct OptionsTests {
      @Test("cellSize option and cellMax value")
      func cellSizeOption() async throws {
         let interpreter = try Interpreter("", options: .init(cellSize: 16))
         
         #expect(interpreter.options.cellMax == 65_535)
         
         try await interpreter.handleInstruction(.decrement)
         #expect(interpreter.tape[0] == 65_535)
      }
      
      @Test("allowCellWraparound option")
      func allowWraparoundOption() async throws {
         let interpreter = try Interpreter("", options: .init(
            allowCellWraparound: false
         ))
         
         await #expect(throws: Interpreter.Error.cellUnderflow(position: 0)) {
            try await interpreter.handleInstruction(.decrement)
         }
         
         interpreter.currentCellValue = interpreter.options.cellMax
         await #expect(throws: Interpreter.Error.cellOverflow(position: 0)) {
            try await interpreter.handleInstruction(.increment)
         }
      }
      
      @Suite("End of input behavior options")
      struct EndOfInputBehaviorTests {
         @Test("Do nothing on end of input")
         func doNothingOption() async throws {
            let interpreter = try Interpreter("", options: .init(
               endOfInputBehavior: nil
            ))
            
            interpreter.currentCellValue = 42
            try await interpreter.handleInstruction(.input)
            #expect(interpreter.currentCellValue == 42)
         }
         
         @Test("Set the current cell to a value on end of input")
         func setToValueOption() async throws {
            let interpreter = try Interpreter("", options: .init(
               endOfInputBehavior: .setTo(0)
            ))
            
            interpreter.currentCellValue = 42
            try await interpreter.handleInstruction(.input)
            #expect(interpreter.currentCellValue == 0)
         }
         
         @Test("Set the current cell to an out-of-bounds value on end of input")
         func setToValueOption_outOfRange() async throws {
            let interpreter = try Interpreter("", options: .init(
               endOfInputBehavior: .setTo(.max)
            ))
            
            interpreter.currentCellValue = 42
            try await interpreter.handleInstruction(.input)
            #expect(
               interpreter.currentCellValue == 255,
               "if the provided value is too large, `setTo` will truncate it"
            )
         }
         
         @Test("Throw an error on end of input")
         func throwErrorOption() async throws {
            let interpreter = try Interpreter("", options: .init(
               endOfInputBehavior: .throwError
            ))
            
            await #expect(throws: Interpreter.Error.endOfInput) {
               try await interpreter.handleInstruction(.input)
            }
         }
      }
   }
}
