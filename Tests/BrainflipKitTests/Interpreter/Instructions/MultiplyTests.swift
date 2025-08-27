// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Mutliply instruction")
  struct MultiplyTests {
    var interpreter: Interpreter<String.UnicodeScalarView, String>
    init() throws {
      self.interpreter = try .init(
        "",
        options: .init(allowCellWraparound: false)
      )
    }

    @Test("Multiply instruction")
    mutating func multiplyInstruction() async throws {
      interpreter.currentCellValue = 3
      interpreter.tape[2] = 5
      try await interpreter.handleInstruction(
        .multiply(factor: 4, offset: 2)
      )
      #expect(interpreter.tape[2] == 17)  // (3*4) + 5
      #expect(interpreter.currentCellValue == 0)
    }

    @Test("Multiply overflow (multiplication)")
    mutating func multiplyOverflowMultiplication() async throws {
      interpreter.currentCellValue = .max
      interpreter.tape[2] = 5
      await #expect(throws: InterpreterError.cellOverflow(position: 0)) {
        try await interpreter.handleInstruction(
          .multiply(factor: 4, offset: 2)
        )
      }
    }

    @Test("Multiply overflow (addition)")
    mutating func multiplyOverflowAddition() async throws {
      interpreter.currentCellValue = 3
      interpreter.tape[2] = .max
      await #expect(throws: InterpreterError.cellOverflow(position: 2)) {
        try await interpreter.handleInstruction(
          .multiply(factor: 4, offset: 2)
        )
      }
    }
  }
}
