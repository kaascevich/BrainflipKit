// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Move instruction")
  struct MovementTests {
    var interpreter: Interpreter<String.UnicodeScalarView, String>
    init() throws {
      self.interpreter = try .init("")
    }

    @Test("Move instruction - right")
    mutating func moveInstructionRight() async throws {
      for i in 1...10 {
        try await interpreter.handleInstruction(.move(1))
        #expect(interpreter.cellPointer == i)
      }
    }

    @Test("Move instruction - left")
    mutating func moveInstructionLeft() async throws {
      for i in (1...10).map(-) {
        try await interpreter.handleInstruction(.move(-1))
        #expect(interpreter.cellPointer == i)
      }
    }
  }
}
