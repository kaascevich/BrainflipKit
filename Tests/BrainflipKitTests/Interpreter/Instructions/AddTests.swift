// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Add instruction")
  struct AddTests {
    var interpreter = Interpreter()

    @Test("Add instruction", arguments: -5...5)
    mutating func addInstruction(offset: CellValue) {
      for i in 1...10 {
        interpreter.handleInstruction(.add(offset))
        
        #expect(
          interpreter.state.currentCellValue == i * offset,
          """
          add instruction adds the given value to the current cell
          """
        )
      }
    }

    @Test("Add instruction - wraparound")
    mutating func addInstructionWraparound() {
      interpreter.state.currentCellValue = .max
      interpreter.handleInstruction(.add(1))
      
      #expect(
        interpreter.state.currentCellValue == .min,
        """
        add instruction with positive value should wrap around
        """
      )
    }

    @Test("Add instruction - negative wraparound")
    mutating func addInstructionNegativeWraparound() {
      interpreter.state.currentCellValue = .min
      interpreter.handleInstruction(.add(-1))

      #expect(
        interpreter.state.currentCellValue == .max,
        """
        add instruction with negative value should wrap around
        """
      )
    }
  }
}
