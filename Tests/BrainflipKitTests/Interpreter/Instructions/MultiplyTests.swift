// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Multiply instruction")
  struct MultiplyTests {
    var interpreter = Interpreter()

    @Test("Multiply instruction")
    mutating func multiplyInstruction() throws {
      interpreter.state.currentCellValue = 5
      interpreter.state.tape[-2] = 4
      try interpreter.handleInstruction(.multiply([1: 2, -2: 7], final: 3))

      #expect(
        interpreter.state.tape[-2] == 39 && interpreter.state.tape[1] == 10,
        """
        multiply instruction multiplies the given values by the current cell
        value, then adds the results to the cells at the corresponding offsets
        """
      )

      #expect(
        interpreter.state.currentCellValue == 3,
        """
        multiply instruction sets the current cell to the given final value
        """
      )
    }
  }
}
