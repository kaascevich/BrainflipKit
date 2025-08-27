// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Input instruction")
  struct InputTests {
    @Test("Input instruction")
    func inputInstruction() async throws {
      var interpreter = try Interpreter("", input: "&")

      try await interpreter.handleInstruction(.input)
      #expect(interpreter.currentCellValue == 0x26)  // ASCII code for "&"
    }
  }
}
