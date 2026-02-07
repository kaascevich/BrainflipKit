// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
    @Suite("Move instruction") struct MoveTests {
        var interpreter = Interpreter()

        /// A move instruction adjusts the cell pointer by the given offset.
        @Test(arguments: -5...5)
        mutating func `Move instruction`(offset: CellOffset) {
            for i in 1...10 {
                interpreter.handleInstruction(.move(offset))
                #expect(interpreter.state.cellPointer == i * offset)
            }
        }
    }
}
