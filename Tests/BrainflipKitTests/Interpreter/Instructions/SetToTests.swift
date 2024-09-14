// SetToTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests.InstructionTests {
  @Suite("Set-to instruction")
  struct SetToTests {
    @Test("Set-to instruction")
    func setToInstruction() async throws {
      var interpreter = try Interpreter("")
      
      interpreter.currentCellValue = 69
      try await interpreter.handleInstruction(.setTo(42))
      #expect(interpreter.currentCellValue == 42)
    }
  }
}
