// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation
import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Program execution")
  struct ExecutionTests {
    let interpreter = Interpreter()

    @Test("Basic program")
    func basicProgram() throws {
      // increments cell 1 and decrements cell 2
      let program = try Program("+>-<")
      let state = try interpreter.run(program)

      #expect(state.tape == [0: 1, 1: -1])
      #expect(state.cellPointer == 0)
    }

    @Test("Simple loops")
    func simpleLoops() throws {
      // sets cell 2 to 9
      let program = try Program("+++[>+++<-]")
      let state = try interpreter.run(program)

      #expect(state.tape[1] == 9)
    }

    @Test("Nested loops")
    func nestedLoops() throws {
      // sets cell 3 to 27
      let program = try Program("+++[>+++[>+++<-]<-]")
      let state = try interpreter.run(program)

      #expect(state.tape[2] == 27)
    }

    @Test("Running with input")
    func runningWithInput() throws {
      // outputs the first input character twice, then the
      // third character once
      let program = try Program(",..,,.")
      let interpreter = Interpreter(input: "hello")

      let output = try interpreter.run(program).output
      #expect(output == "hhl")
    }

    @Test("'Hello World!' program")
    func helloWorldProgram() throws {
      let source = try #require(getProgram(named: "helloworld"))
      let program = try Program(source)

      let output = try interpreter.run(program).output
      #expect(output == "Hello World!")
    }

    @Test("Comprehensive test", .timeLimit(.minutes(1)))
    func comprehensiveTest() throws {
      let source = try #require(getProgram(named: "comprehensive"))
      let program = try Program(source)

      let output = try interpreter.run(program).output
      #expect(output == "Hello, world!\n")
    }

    @Test("Factorization test", .timeLimit(.minutes(1)))
    func factorizationTest() throws {
      let source = try #require(getProgram(named: "factor"))
      let program = try Program(source)
      let interpreter = Interpreter(input: "2346\n")

      let output = try interpreter.run(program).output
      #expect(output == "2346: 2 3 17 23\n")
    }
  }
}
