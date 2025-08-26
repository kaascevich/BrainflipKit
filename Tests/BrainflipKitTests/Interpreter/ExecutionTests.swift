// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

import Foundation
import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Program execution")
  struct ExecutionTests {
    @Test("Basic program")
    func basicProgram() async throws {
      // increments cell 1 and decrements cell 2
      let interpreter = try Interpreter("+>-<")

      let state = try await interpreter.runReturningFinalState()

      #expect(
        state.tape == [
          0: 1,
          1: .max,
        ]
      )
      #expect(state.cellPointer == 0)
    }

    @Test("Simple loops")
    func simpleLoops() async throws {
      // sets cell 2 to 9
      let interpreter = try Interpreter("+++[>+++<-]")

      let state = try await interpreter.runReturningFinalState()
      #expect(state.tape[1] == 9)
    }

    @Test("Nested loops")
    func nestedLoops() async throws {
      // sets cell 3 to 27
      let interpreter = try Interpreter("+++[>+++[>+++<-]<-]")

      let state = try await interpreter.runReturningFinalState()
      #expect(state.tape[2] == 27)
    }

    @Test("Running with input")
    func runningWithInput() async throws {
      // outputs the first input character twice, then the
      // third character once
      let interpreter = try Interpreter(",..,,.", input: "hello")

      let output = try await interpreter.run()
      #expect(output == "hhl")
    }

    @Test("'Hello World!' program")
    func helloWorldProgram() async throws {
      let program = """
        ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>
        .>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.
        """
      let interpreter = try Interpreter(program)

      let output = try await interpreter.run()
      #expect(output == "Hello World!")
    }

    // FIXME: Times out
    @Test("Comprehensive test", .timeLimit(.minutes(1)))
    func comprehensiveTest() async throws {
      let program = try String(
        contentsOf: Bundle.module.url(
          forResource: "Resources/Examples/comprehensive",
          withExtension: "bf"
        )!,
        encoding: .utf8
      )
      let interpreter = try Interpreter(program)

      let output = try await interpreter.run()
      #expect(output == "Hello, world!\n")
    }
  }
}
