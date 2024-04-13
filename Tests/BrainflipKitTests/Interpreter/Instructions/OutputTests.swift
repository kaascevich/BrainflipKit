// OutputTests.swift
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

// swiftlint:disable force_cast

extension InterpreterTests.InstructionTests {
   @Suite("Output instruction")
   struct OutputTests {
      @Test("Output instruction")
      func outputInstruction() async throws {
         var interpreter = try await Interpreter("")

         interpreter.currentCellValue = 0x42 // ASCII code for "B"
         try await interpreter.handleInstruction(.output)
         #expect(interpreter.outputStream as! String == "B")
      }
      
      @Test("Output instruction with Unicode characters")
      func outputInstruction_unicode() async throws {
         var interpreter = try await Interpreter("")
         
         interpreter.currentCellValue = 0x2192 // Unicode value for "→"
         try await interpreter.handleInstruction(.output)
         #expect(interpreter.outputStream as! String == "→")
      }
   }
}

// swiftlint:enable force_cast
