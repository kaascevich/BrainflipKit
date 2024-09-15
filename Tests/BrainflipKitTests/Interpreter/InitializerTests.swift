// InitializerTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests {
  @Suite("Interpreter initialization")
  struct InitializerTests {
    @Test("Default initializer")
    func defaultInitializer() throws {
      let interpreter = try Interpreter("")
      
      #expect(interpreter.tape.isEmpty)
      #expect(interpreter.cellPointer == 0)
      #expect(interpreter.outputStream as? String == "") // swiftlint:disable:this empty_string
      
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
      #expect(output as? String == "→")
    }
  }
}
