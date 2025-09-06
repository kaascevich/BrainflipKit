// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Move instruction")
  struct MovementTests {
    var interpreter = Interpreter()

    @Test("Move instruction", arguments: -5...5)
    mutating func moveInstruction(offset: CellOffset) throws {
      for i in 1...10 {
        try interpreter.handleInstruction(.move(offset))
        
        #expect(
          interpreter.state.cellPointer == i * offset,
          """
          move instruction should move the cell pointer by the given offset
          """
        )
      }
    }
  }
}
