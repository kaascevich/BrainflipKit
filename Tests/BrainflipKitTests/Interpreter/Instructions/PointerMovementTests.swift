// PointerMovementTests.swift
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
   @Suite("Next cell & previous cell instructions")
   struct PointerMovementTests {
      var interpreter: Interpreter
      init() throws {
         interpreter = try Interpreter("")
      }
      
      @Test("Next cell instruction")
      func nextCellInstruction() async throws {
         for i in 1...10 {
            try await interpreter.handleInstruction(.nextCell)
            #expect(interpreter.cellPointer == i)
         }
      }
      
      @Test("Previous cell instruction")
      func prevCellInstruction() async throws {
         for i in 1...10 {
            try await interpreter.handleInstruction(.prevCell)
            #expect(interpreter.cellPointer == -i) // the pointer can go anywhere now!
         }
      }
   }
}
