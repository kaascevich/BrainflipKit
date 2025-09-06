// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import CustomDump
import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Program execution")
  struct ExecutionTests {
    var interpreter = Interpreter()

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
      // sets cell 2 to 9, clears cell 1 in the process
      let program = try Program("+++[>+++<-]")
      let state = try interpreter.run(program)

      #expect(state.tape[0] == 0)
      #expect(state.tape[1] == 9)
    }

    @Test("Nested loops")
    func nestedLoops() throws {
      // sets cell 3 to 27, clears cells 1 and 2 in the process
      let program = try Program("+++[>+++[>+++<-]<-]")
      let state = try interpreter.run(program)

      #expect(state.tape[0] == 0)
      #expect(state.tape[1] == 0)
      #expect(state.tape[2] == 27)
    }

    @Test("Running with input")
    mutating func runningWithInput() throws {
      // outputs the first input character twice, then the
      // third character once
      let program = try Program(",..,,.")
      interpreter = Interpreter(input: "hello")

      let output = try interpreter.run(program).output
      
      #expect(output == "hhl")
    }

    @Test("'Hello World!' program")
    func helloWorldProgram() throws {
      let program = try getProgram(named: "helloworld")
      let output = try interpreter.run(program).output

      #expect(output == "Hello World!")
    }

    @Test("Comprehensive test", .timeLimit(.minutes(1)))
    func comprehensiveTest() throws {
      let program = try getProgram(named: "comprehensive")
      let output = try interpreter.run(program).output

      #expect(output == "Hello, world!\n")
    }

    @Test("Factorization test", .timeLimit(.minutes(1)))
    mutating func factorizationTest() throws {
      let program = try getProgram(named: "factor")
      interpreter = Interpreter(input: "2346\n")
      let output = try interpreter.run(program).output

      #expect(output == "2346: 2 3 17 23\n")
    }

    @Test("Obscure problem tester", .timeLimit(.minutes(1)))
    func obscureProblemTester() throws {
      let program = try getProgram(named: "obscure")
      let output = try interpreter.run(program).output

      #expect(output == "H\n")
    }
  }
}
