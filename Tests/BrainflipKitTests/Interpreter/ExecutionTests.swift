// ExecutionTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests {
  @Suite("Program execution")
  struct ExecutionTests {
    @Test("Basic program")
    func basicProgram() async throws {
      // increments cell 1 and decrements cell 2
      let interpreter = try await Interpreter("+>-<")
      
      let state = try await interpreter.runReturningFinalState()
      
      #expect(state.tape == [
        0: 1,
        1: .max
      ])
      #expect(state.cellPointer == 0)
    }
    
    @Test("Simple loops")
    func simpleLoops() async throws {
      // sets cell 2 to 9
      let interpreter = try await Interpreter("+++[>+++<-]")
      
      let state = try await interpreter.runReturningFinalState()
      #expect(state.tape[1] == 9)
    }
    
    @Test("Nested loops")
    func nestedLoops() async throws {
      // sets cell 3 to 27
      let interpreter = try await Interpreter("+++[>+++[>+++<-]<-]")
      
      let state = try await interpreter.runReturningFinalState()
      #expect(state.tape[2] == 27)
    }
    
    @Test("Running with input")
    func runningWithInput() async throws {
      // outputs the first input character twice, then the
      // third character once
      let interpreter = try await Interpreter(",..,,.", input: "hello")
      
      let output = try await interpreter.run()
      #expect(output as! String == "hhl")
    }
    
    @Test("'Hello World!' program")
    func helloWorldProgram() async throws {
      let program = """
      ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>
      .>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.
      """
      let interpreter = try await Interpreter(program)
      
      let output = try await interpreter.run()
      #expect(output as! String == "Hello World!")
    }
  }
}
