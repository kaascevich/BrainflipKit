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
@testable import class BrainflipKit.Interpreter

extension InterpreterTests {
   @Suite("Interpreter initialization")
   struct InitializerTests {
      @Test("Default initializer")
      func defaultInitializer() throws {
         let interpreter = try Interpreter("")
         
         #expect(interpreter.tape.isEmpty)
         #expect(interpreter.cellPointer == 0)
         #expect(interpreter.outputBuffer.isEmpty)
         
         #expect(interpreter.originalInput.isEmpty)
         #expect(interpreter.program.isEmpty)
      }
      
      @Test("Unicode input")
      func unicodeInput() throws {
         let interpreter = try Interpreter(
            "",
            input: "→",
            options: .init(cellSize: 16)
         )
         #expect(interpreter.originalInput == "→")
      }
      
      @Test("Unicode input that doesn't fit")
      func unicodeInput_valueTooBig() throws {
         let interpreter = try Interpreter(
            "",
            input: "→",
            options: .init(cellSize: 8)
         )
         #expect(interpreter.originalInput.isEmpty)
      }
   }
}
