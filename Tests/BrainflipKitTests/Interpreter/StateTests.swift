// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite struct `State` {
    var interpreter = Interpreter()

    @Test mutating func `Current cell value`() {
      interpreter.state.tape = [0: 237, 1: 29, 2: 74]

      #expect(interpreter.state.currentCellValue == 237)

      interpreter.state.cellPointer = 1
      #expect(interpreter.state.currentCellValue == 29)

      interpreter.state.cellPointer = 2
      #expect(interpreter.state.currentCellValue == 74)
    }
  }
}
