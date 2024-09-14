// MultiplyTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests.InstructionTests {
  @Suite("Mutliply instruction")
  struct MultiplyTestsTests {
    @Test("Multiply instruction")
    func multiplyInstruction() async throws {
      var interpreter = try await Interpreter("")
      
      interpreter.currentCellValue = 3
      interpreter.tape[2] = 5
      try await interpreter.handleInstruction(
        .multiply(factor: 4, offset: 2)
      )
      #expect(interpreter.tape[2] == 17) // (3*4) + 5
      #expect(interpreter.currentCellValue == 0)
    }
  }
}
