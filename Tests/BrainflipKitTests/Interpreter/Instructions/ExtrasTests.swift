// ExtrasTests.swift
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
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests.InstructionTests {
   @Suite("Extra instructions")
   struct ExtrasTests {
      @Test("No instructions enabled") func disabledInstructions() async throws {
         await #expect(
            throws: Never.self,
            "stop insrtuction does nothing when not enabled"
         ) {
            let interpreter = try Interpreter("!")
            
            // if this throws, then the stop instruction
            // has been executed even though we don't want
            // it to be
            _ = try await interpreter.run()
         }
      }
      
      @Test("Stop instruction")
      func stopInstruction() async throws {
         var interpreter = try Interpreter("", options: .init(
            enabledExtraInstructions: [.stop]
         ))
         
         await #expect(
            throws: Interpreter.Error.stopInstruction,
            "stop instruction halts the program by throwing an error"
         ) {
            try await interpreter.handleInstruction(.extra(.stop))
         }
      }
      
      @Test("Zero instruction")
      func zeroInstruction() async throws {
         var interpreter = try Interpreter("", options: .init(
            enabledExtraInstructions: [.zero]
         ))
         
         interpreter.currentCellValue = 42
         try await interpreter.handleInstruction(.extra(.zero))
         #expect(
            interpreter.currentCellValue == 0,
            "zero instruction sets the current cell to zero"
         )
      }
   }
}
