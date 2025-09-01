// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation
import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Program execution") struct ExecutionTests {
    @Test("Basic program")
    func basicProgram() throws {
      // increments cell 1 and decrements cell 2
      let interpreter = try Interpreter("+>-<")

      let state = try interpreter.runReturningFinalState()

      #expect(state.tape == [0: 1, 1: -1])
      #expect(state.cellPointer == 0)
    }

    @Test("Simple loops")
    func simpleLoops() throws {
      // sets cell 2 to 9
      let interpreter = try Interpreter("+++[>+++<-]")

      let state = try interpreter.runReturningFinalState()
      #expect(state.tape[1] == 9)
    }

    @Test("Nested loops")
    func nestedLoops() throws {
      // sets cell 3 to 27
      let interpreter = try Interpreter("+++[>+++[>+++<-]<-]")

      let state = try interpreter.runReturningFinalState()
      #expect(state.tape[2] == 27)
    }

    @Test("Running with input")
    func runningWithInput() throws {
      // outputs the first input character twice, then the
      // third character once
      let interpreter = try Interpreter(",..,,.", input: "hello")

      let output = try interpreter.run()
      #expect(output == "hhl")
    }

    @Test("'Hello World!' program")
    func helloWorldProgram() throws {
      let program = try #require(exampleProgram(named: "helloworld"))
      let interpreter = try Interpreter(program)

      let output = try interpreter.run()
      #expect(output == "Hello World!")
    }

    @Test("Comprehensive test", .timeLimit(.minutes(1)))
    func comprehensiveTest() throws {
      let program = try #require(exampleProgram(named: "comprehensive"))
      let interpreter = try Interpreter(program)

      let output = try interpreter.run()
      #expect(output == "Hello, world!\n")
    }

    @Test("Factorization test", .timeLimit(.minutes(1)))
    func factorizationTest() throws {
      let program = try #require(exampleProgram(named: "factor"))
      let interpreter = try Interpreter(program, input: "2346\n")

      let output = try interpreter.run()
      #expect(output == "2346: 2 3 17 23\n")
    }
  }
}
