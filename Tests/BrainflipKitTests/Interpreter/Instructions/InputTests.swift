// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Input instruction") struct InputTests {
    @Test func `Input instruction`() {
      var interpreter = Interpreter(input: "&a")

      interpreter.handleInstruction(.input)

      #expect(
        interpreter.state.currentCellValue == 0x26,  // ASCII code for "&"
        """
        input instruction puts the current input character's Unicode value \
        into the current cell
        """
      )

      interpreter.handleInstruction(.input)

      #expect(
        interpreter.state.currentCellValue == 0x61,  // ASCII code for "a"
        "input instruction moves to the next input character when executed"
      )

      interpreter.handleInstruction(.input)

      #expect(
        interpreter.state.currentCellValue == 0x61,  // ASCII code for "a"
        """
        input instruction doesn't change the current cell value when end of \
        input is reached
        """
      )
    }
  }
}
