// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Interpreter options")
  struct OptionsTests {
    @Suite("End of input behavior options")
    struct EndOfInputBehaviorTests {
      @Test("Do nothing on end of input")
      func doNothingOption() {
        var interpreter = Interpreter(
          options: .init(endOfInputBehavior: nil)
        )

        interpreter.state.currentCellValue = 42
        interpreter.handleInstruction(.input)
        #expect(interpreter.state.currentCellValue == 42)
      }

      @Test("Set the current cell to a value on end of input")
      func setToValueOption() {
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
