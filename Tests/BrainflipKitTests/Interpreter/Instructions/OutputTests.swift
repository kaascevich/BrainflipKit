// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
    @Suite("Output instruction") struct OutputTests {
        var interpreter = Interpreter()

        @Test mutating func `Output instruction`() {
            interpreter.state.currentCellValue = 0x42  // ASCII code for "B"
            interpreter.handleInstruction(.output)

            #expect(
                interpreter.state.output == "B",
                """
                output instruction outputs the Unicode character corresponding to the \
                current cell value
                """
            )

            interpreter.handleInstruction(.output)

            #expect(
                interpreter.state.output == "BB",
                "output instruction appends the character to the existing output"
            )
        }

        /// The output instruction correctly outputs Unicode characters.
        @Test mutating func `Output instruction with Unicode characters`() {
            // Unicode value for "→"
            interpreter.state.currentCellValue = 0x2192

            interpreter.handleInstruction(.output)
            #expect(interpreter.state.output == "→")
        }

        /// The output instruction does nothing when the current cell value doesn't
        /// correspond to a valid Unicode character.
        @Test mutating func `Output instruction with invalid Unicode characters`() {
            // max Unicode value is 0x10FFFF
            interpreter.state.currentCellValue = 0x110000

            interpreter.handleInstruction(.output)
            #expect(interpreter.state.output.isEmpty)
        }
    }
}
