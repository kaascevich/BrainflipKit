// InitializerTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

import Testing
@testable import struct BrainflipKit.Interpreter

// swiftlint:disable force_cast

extension InterpreterTests {
   @Suite("Interpreter initialization")
   struct InitializerTests {
      @Test("Default initializer")
      func defaultInitializer() async throws {
         let interpreter = try await Interpreter("")
         
         #expect(interpreter.tape.isEmpty)
         #expect(interpreter.cellPointer == 0)
         #expect((interpreter.outputStream as! String).isEmpty)
         
         #expect(interpreter.program.isEmpty)
      }
      
      @Test("Unicode input")
      func unicodeInput() async throws {
         let interpreter = try await Interpreter(
            ",[.,]",
            input: "→",
            options: .init(endOfInputBehavior: .setTo(0))
         )
         let output = try await interpreter.run()
         #expect(output as! String == "→")
      }
   }
}

// swiftlint:enable force_cast
