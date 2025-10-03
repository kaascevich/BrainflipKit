// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Add instruction") struct AddTests {
    var interpreter = Interpreter()

    /// An add instruction adds the given value to the current cell.
    @Test(arguments: -5...5)
    mutating func `Add instruction`(offset: CellValue) {
      for i in 1...10 {
        interpreter.handleInstruction(.add(offset))

        #expect(interpreter.state.currentCellValue == i * offset)
      }
    }

    /// An add instruction with a positive value wraps around to a negative
    /// value if an overflow occurs.
    @Test mutating func `Add instruction - wraparound`() {
      interpreter.state.currentCellValue = .max
      interpreter.handleInstruction(.add(1))

      #expect(interpreter.state.currentCellValue == .min)
    }

    /// An add instruction with a negative value wraps around to a positive
    /// value if an overflow occurs.
    @Test mutating func `Add instruction - negative wraparound`() {
      interpreter.state.currentCellValue = .min
      interpreter.handleInstruction(.add(-1))

      #expect(interpreter.state.currentCellValue == .max)
    }
  }
}
