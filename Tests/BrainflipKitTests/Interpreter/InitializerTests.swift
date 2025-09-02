// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Interpreter initialization")
  struct InitializerTests {
    @Test("Default initializer")
    func defaultInitializer() {
      let interpreter = Interpreter()

      #expect(interpreter.state.tape.isEmpty)
      #expect(interpreter.state.cellPointer == 0)
      #expect(interpreter.state.currentCellValue == 0)
      #expect(interpreter.state.output.isEmpty == true)
    }

    @Test("Unicode input")
    func unicodeInput() throws {
      let program = try Program(",[.,]")
      let interpreter = Interpreter(
        input: "→",
        options: .init(endOfInputBehavior: .setTo(0))
      )
      let output = try interpreter.run(program).output
      #expect(output == "→")
    }
  }
}
