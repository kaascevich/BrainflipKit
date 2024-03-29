// SetToTests.swift
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
   @Suite("Set-to instruction")
   struct SetToTests {
      @Test("Set-to instruction")
      func setToInstruction() async throws {
         var interpreter = try await Interpreter("")
         
         interpreter.currentCellValue = 69
         try await interpreter.handleInstruction(.setTo(42))
         #expect(interpreter.currentCellValue == 42)
      }
   }
}
