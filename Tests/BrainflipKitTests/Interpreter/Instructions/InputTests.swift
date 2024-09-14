// InputTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests.InstructionTests {
  @Suite("Input instruction")
  struct InputTests {
    @Test("Input instruction")
    func inputInstruction() async throws {
      var interpreter = try await Interpreter("", input: "&")
      
      try await interpreter.handleInstruction(.input)
      #expect(interpreter.currentCellValue == 0x26) // ASCII code for "&"
    }
  }
}
