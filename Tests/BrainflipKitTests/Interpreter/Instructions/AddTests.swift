// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Add instruction")
  struct AddTests {
    var interpreter: Interpreter<String.UnicodeScalarView, String>
    init() throws {
      self.interpreter = try .init("")
    }

    @Test("Add instruction")
    mutating func addInstruction() async throws {
      for i in 1...500 {
        try await interpreter.handleInstruction(.add(1))
        #expect(interpreter.tape.first?.value == CellValue(i))
      }

      interpreter.currentCellValue = .max
      try await interpreter.handleInstruction(.add(1))
      #expect(
        interpreter.tape.first?.value == 0,
        "increment instruction should wrap around"
      )
    }

    @Test("Add instruction - negative")
    mutating func addInstructionNegative() async throws {
      try await interpreter.handleInstruction(.add(-1))
      #expect(
        interpreter.tape.first?.value == .max,
        "decrement instruction should wrap around"
      )

      interpreter.currentCellValue = 500
      for i in (0..<500).reversed() {
        try await interpreter.handleInstruction(.add(-1))
        #expect(interpreter.tape.first?.value == CellValue(i))
      }
    }
  }
}
