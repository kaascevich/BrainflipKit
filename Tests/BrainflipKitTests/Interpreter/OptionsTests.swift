// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests {
    @Suite struct `Interpreter options` {
        @Suite struct `End of input behavior options` {
            @Test func `Do nothing on end of input`() {
                var interpreter = Interpreter(
                    options: .init(endOfInputBehavior: .doNothing)
                )

                interpreter.state.currentCellValue = 42
                interpreter.handleInstruction(.input)
                #expect(interpreter.state.currentCellValue == 42)
            }

            @Test func `Set the current cell to a value on end of input`() {
                var interpreter = Interpreter(
                    options: .init(endOfInputBehavior: .setTo(0))
                )

                interpreter.state.currentCellValue = 42
                interpreter.handleInstruction(.input)
                #expect(interpreter.state.currentCellValue == 0)
            }
        }
    }
}
