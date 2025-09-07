// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Output instruction")
  struct OutputTests {
    var interpreter = Interpreter()

    @Test("Output instruction")
    mutating func outputInstruction() {
      interpreter.state.currentCellValue = 0x42  // ASCII code for "B"
      interpreter.handleInstruction(.output)

      #expect(
        interpreter.state.output == "B",
        """
        output instruction should output the Unicode character corresponding \
        to the current cell value
        """
      )

      interpreter.handleInstruction(.output)

      #expect(
        interpreter.state.output == "BB",
        """
        output instruction should append the character to the existing output
        """
      )
    }

    @Test("Output instruction with Unicode characters")
    mutating func outputInstructionUnicode() {
      interpreter.state.currentCellValue = 0x2192  // Unicode value for "→"
      interpreter.handleInstruction(.output)

      #expect(
        interpreter.state.output == "→",
        """
        output instruction should correctly output Unicode characters
        """
      )
    }

    @Test("Output instruction with invalid Unicode characters")
    mutating func outputInstructionInvalidUnicode() {
      interpreter.state.currentCellValue = 0x110000  // max Unicode value is 0x10FFFF
      interpreter.handleInstruction(.output)

      #expect(
        interpreter.state.output.isEmpty,
        """
        output instruction should do nothing when the current cell value \
        doesn't correspond to a valid Unicode character
        """
      )
    }
  }
}
