// IncDecTests.swift
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

extension InterpreterTests.InstructionTests {
   @Suite("Increment & decrement instructions")
   struct IncDecTests {
      let interpreter: Interpreter
      init() throws {
         interpreter = try Interpreter("")
      }
      
      @Test("Increment instruction")
      func incrementInstruction() async throws {
         for i in 1...interpreter.options.cellMax {
            try await interpreter.handleInstruction(.increment)
            #expect(interpreter.tape.first?.value == i)
         }
         
         try await interpreter.handleInstruction(.increment)
         #expect(
            interpreter.tape.first?.value == 0,
            "increment instruction should wrap around"
         )
      }
         
      @Test("Decrement instruction")
      func decrementInstruction() async throws {
         try await interpreter.handleInstruction(.decrement)
         #expect(
            interpreter.tape.first?.value == interpreter.options.cellMax,
            "decrement instruction should wrap around"
         )
         
         for i in (0..<interpreter.options.cellMax).reversed() {
            try await interpreter.handleInstruction(.decrement)
            #expect(interpreter.tape.first?.value == i)
         }
      }
   }
}
