// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Add instruction")
  struct AddTests {
    var interpreter = Interpreter()

    @Test("Add instruction", arguments: -5...5)
    mutating func addInstruction(offset: CellValue) throws {
      for i in 1...10 {
        try interpreter.handleInstruction(.add(offset))
        #expect(interpreter.state.currentCellValue == i * offset)
      }
    }

    @Test("Add instruction - wraparound")
    mutating func addInstructionWraparound() throws {
      interpreter.state.currentCellValue = .max
      try interpreter.handleInstruction(.add(1))
      
      #expect(
        interpreter.state.currentCellValue == .min,
        "increment instruction should wrap around"
      )
    }

    @Test("Add instruction - negative wraparound")
    mutating func addInstructionNegativeWraparound() throws {
      interpreter.state.currentCellValue = .min
      try interpreter.handleInstruction(.add(-1))

      #expect(
        interpreter.state.currentCellValue == .max,
        "decrement instruction should wrap around"
      )
    }
  }
}
