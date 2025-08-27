// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Interpreter initialization")
  struct InitializerTests {
    @Test("Default initializer")
    func defaultInitializer() throws {
      let interpreter = try Interpreter("")

      #expect(interpreter.tape.isEmpty)
      #expect(interpreter.cellPointer == 0)
      #expect(interpreter.outputStream.isEmpty == true)

      #expect(interpreter.program.isEmpty)
    }

    @Test("Unicode input")
    func unicodeInput() async throws {
      let interpreter = try Interpreter(
        ",[.,]",
        input: "→",
        options: .init(endOfInputBehavior: .setTo(0))
      )
      let output = try await interpreter.run()
      #expect(output == "→")
    }
  }
}
