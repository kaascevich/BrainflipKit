// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Set-to instruction")
  struct SetToTests {
    var interpreter: Interpreter<String.UnicodeScalarView, String>
    init() throws {
      self.interpreter = try .init("")
    }

    @Test("Set-to instruction")
    mutating func setToInstruction() throws {
      try interpreter.handleInstruction(.setTo(42))
      #expect(interpreter.currentCellValue == 42)
    }
  }
}
