// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Set-to instruction")
  struct SetToTests {
    var interpreter = Interpreter()

    @Test("Set-to instruction")
    mutating func setToInstruction() throws {
      try interpreter.handleInstruction(.setTo(42))
      #expect(interpreter.state.currentCellValue == 42)
    }
  }
}
