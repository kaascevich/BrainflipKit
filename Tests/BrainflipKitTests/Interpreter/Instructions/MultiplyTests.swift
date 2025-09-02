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
    mutating func multiplyInstruction() throws {
      interpreter.cellPointer = 0
      interpreter.tape[0] = 3
      interpreter.tape[2] = 5

      try interpreter.handleInstruction(
        .multiply(factor: 4, offset: 2)
      )
      #expect(interpreter.tape[2] == 17)  // (3*4) + 5
      #expect(interpreter.currentCellValue == 0)
    }

    @Test("Multiply overflow (multiplication)")
    mutating func multiplyOverflowMultiplication() throws {
      interpreter.cellPointer = 0
      interpreter.tape[0] = .max
      interpreter.tape[2] = 5
      #expect(throws: InterpreterError.cellOverflow(position: 0)) {
        try interpreter.handleInstruction(
          .multiply(factor: 4, offset: 2)
        )
      }
    }

    @Test("Multiply overflow (addition)")
    mutating func multiplyOverflowAddition() throws {
      interpreter.cellPointer = 0
      interpreter.tape[0] = 3
      interpreter.tape[2] = .max
      #expect(throws: InterpreterError.cellOverflow(position: 2)) {
        try interpreter.handleInstruction(
          .multiply(factor: 4, offset: 2)
        )
      }
    }
  }
}
