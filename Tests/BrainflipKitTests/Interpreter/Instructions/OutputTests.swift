// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Output instruction")
  struct OutputTests {
    var interpreter: Interpreter<String.UnicodeScalarView, String>
    init() throws {
      self.interpreter = try .init("")
    }

    @Test("Output instruction")
    mutating func outputInstruction() throws {
      interpreter.currentCellValue = 0x42  // ASCII code for "B"
      try interpreter.handleInstruction(.output)
      #expect(interpreter.output == "B")
    }

    @Test("Output instruction with Unicode characters")
    mutating func outputInstructionUnicode() throws {
      interpreter.currentCellValue = 0x2192  // Unicode value for "→"
      try interpreter.handleInstruction(.output)
      #expect(interpreter.output == "→")
    }

    @Test("Output instruction with invalid Unicode characters")
    mutating func outputInstructionInvalidUnicode() throws {
      interpreter.currentCellValue = 0x110000  // max Unicode value is 0x10FFFF
      try interpreter.handleInstruction(.output)
      #expect(interpreter.output.isEmpty)
    }
  }
}
