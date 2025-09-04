// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Scan instruction")
  struct ScanTests {
    var interpreter = Interpreter()

    @Test("Scan instruction")
    mutating func scanInstruction() throws {
      interpreter.state.tape = [
        0: 1,
        1: 2,
        2: 3,
        3: 0,  // this cell is zero, but at an odd index
        4: 5,
        5: 6,
        6: 0,  // this cell is zero, and at an even index
      ]

      try interpreter.handleInstruction(.scan(2))
      
      #expect(
        interpreter.state.cellPointer == 6,
        """
        scan instruction repeatedly moves the cell pointer by the \
        specified amount until it lands on a zero cell
        """
      )
    }
  }
}
