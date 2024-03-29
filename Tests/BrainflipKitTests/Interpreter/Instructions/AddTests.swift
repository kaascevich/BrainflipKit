// AddTests.swift
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
   @Suite("Add instruction")
   struct AddTests {
      @Test("Add instruction")
      func addInstruction() async throws {
         var interpreter = try await Interpreter("")
         
         for i in 1...500 {
            try await interpreter.handleInstruction(.add(1))
            #expect(interpreter.tape.first?.value == UInt32(i))
         }
         
         interpreter.currentCellValue = .max
         try await interpreter.handleInstruction(.add(1))
         #expect(
            interpreter.tape.first?.value == .min,
            "increment instruction should wrap around"
         )
      }
         
      @Test("Add instruction - negative")
      func addInstruction_negative() async throws {
         var interpreter = try await Interpreter("")
         
         try await interpreter.handleInstruction(.add(-1))
         #expect(
            interpreter.tape.first?.value == .max,
            "decrement instruction should wrap around"
         )
         
         interpreter.currentCellValue = 500
         for i in (0..<500).reversed() {
            try await interpreter.handleInstruction(.add(-1))
            #expect(interpreter.tape.first?.value == UInt32(i))
         }
      }
   }
}
