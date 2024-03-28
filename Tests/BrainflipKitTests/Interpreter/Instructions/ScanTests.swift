// ScanTests.swift
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
   @Suite("Scan instructions")
   struct ScanTests {
      @Test("Scan left instruction")
      func scanLeftInstruction() async throws {
         var interpreter = try Interpreter("")
         
         interpreter.tape = [
            0: 1,
            1: 2,
            2: 3,
            3: 4,
            4: 5
         ]
         interpreter.cellPointer = 4
         
         try await interpreter.handleInstruction(.scanLeft)
         #expect(
            interpreter.cellPointer == -1,
            "scan left instruction moves the cell pointer to the previous zero cell"
         )
      }
      
      @Test("Scan right instruction")
      func scanRightInstruction() async throws {
         var interpreter = try Interpreter("")
         
         interpreter.tape = [
            0: 1,
            1: 2,
            2: 3,
            3: 4,
            4: 5,
            5: 0
         ]
         
         try await interpreter.handleInstruction(.scanRight)
         #expect(
            interpreter.cellPointer == 5,
            "scan right instruction moves the cell pointer to the next zero cell"
         )
      }
   }
}
