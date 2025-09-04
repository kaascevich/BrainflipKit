// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Input instruction")
  struct InputTests {
    @Test("Input instruction")
    func inputInstruction() throws {
      var interpreter = Interpreter(input: "&a")

      try interpreter.handleInstruction(.input)

      #expect(
        interpreter.state.currentCellValue == 0x26,  // ASCII code for "&"
        """
        input instruction should put the current input character's Unicode \
        value into the current cell
        """
      )

      try interpreter.handleInstruction(.input)

      #expect(
        interpreter.state.currentCellValue == 0x61,  // ASCII code for "a"
        """
        input instruction should move to the next input character when executed
        """
      )

      try interpreter.handleInstruction(.input)
      
      #expect(
        interpreter.state.currentCellValue == 0x61,  // ASCII code for "a"
        """
        input instruction shouldn't change the current cell value when end of \
        input is reached
        """
      )
    }
  }
}
