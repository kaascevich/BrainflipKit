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
   @Suite("Scan instruction")
   struct ScanTests {
      @Test("Scan instruction")
      func scanInstruction() async throws {
         var interpreter = try await Interpreter("")
         
         interpreter.tape = [
            0: 1,
            1: 2,
            2: 3,
            3: 0, // this cell is zero, but at an odd index
            4: 5,
            5: 6,
            6: 0, // this cell is zero, and at an even index
         ]
         
         try await interpreter.handleInstruction(.scan(2))
         #expect(
            interpreter.cellPointer == 6,
            """
            scan instruction repeatedly moves the cell pointer by the \
            specified amount until it lands on a zero cell
            """
         )
      }
   }
}
