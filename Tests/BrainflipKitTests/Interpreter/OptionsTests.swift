// OptionsTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests {
   @Suite("Interpreter options")
   struct OptionsTests {
      @Test("allowCellWraparound option")
      func allowWraparoundOption() async throws {
         var interpreter = try Interpreter("", options: .init(
            allowCellWraparound: false
         ))
         
         await #expect(throws: Interpreter.Error.cellUnderflow(position: 0)) {
            try await interpreter.handleInstruction(.add(-1))
         }
         
         interpreter.currentCellValue = .max
         await #expect(throws: Interpreter.Error.cellOverflow(position: 0)) {
            try await interpreter.handleInstruction(.add(1))
         }
      }
      
      @Suite("End of input behavior options")
      struct EndOfInputBehaviorTests {
         @Test("Do nothing on end of input")
         func doNothingOption() async throws {
            var interpreter = try Interpreter("", options: .init(
               endOfInputBehavior: nil
            ))
            
            interpreter.currentCellValue = 42
            try await interpreter.handleInstruction(.input)
            #expect(interpreter.currentCellValue == 42)
         }
         
         @Test("Set the current cell to a value on end of input")
         func setToValueOption() async throws {
            var interpreter = try Interpreter("", options: .init(
               endOfInputBehavior: .setTo(0)
            ))
            
            interpreter.currentCellValue = 42
            try await interpreter.handleInstruction(.input)
            #expect(interpreter.currentCellValue == 0)
         }
         
         @Test("Throw an error on end of input")
         func throwErrorOption() async throws {
            var interpreter = try Interpreter("", options: .init(
               endOfInputBehavior: .throwError
            ))
            
            await #expect(throws: Interpreter.Error.endOfInput) {
               try await interpreter.handleInstruction(.input)
            }
         }
      }
   }
}
