// OutputTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Output instruction")
  struct OutputTests {
    @Test("Output instruction")
    func outputInstruction() async throws {
      var interpreter = try Interpreter("")

      interpreter.currentCellValue = 0x42 // ASCII code for "B"
      try await interpreter.handleInstruction(.output)
      #expect(interpreter.outputStream as? String == "B")
    }
    
    @Test("Output instruction with Unicode characters")
    func outputInstruction_unicode() async throws {
      var interpreter = try Interpreter("")
      
      interpreter.currentCellValue = 0x2192 // Unicode value for "→"
      try await interpreter.handleInstruction(.output)
      #expect(interpreter.outputStream as? String == "→")
    }
  }
}
