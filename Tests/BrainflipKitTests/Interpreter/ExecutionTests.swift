// ExecutionTests.swift
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
         // second character once
         let interpreter = try await Interpreter(",..,.", input: "hello")
         
         let output = try await interpreter.run()
         #expect(output == "hhe")
      }
      
      @Test("'Hello World!' program")
      func helloWorldProgram() async throws {
         let program = """
         ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>
         .>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.
         """
         let interpreter = try await Interpreter(program)
         
         let output = try await interpreter.run()
         #expect(output == "Hello World!")
      }
   }
}
