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

import class XCTest.XCTestCase
import Nimble
@testable import class BrainflipKit.Interpreter

extension InterpreterTests {
   internal final class ExecutionTests: XCTestCase {
      internal func testBasicRun() async throws {
         // increments cell 1 and decrements cell 2
         try await with(Interpreter("+>-<")) {
            _ = try await $0.run()
            
            expect($0.tape) == [0: 1, 1: $0.options.cellMax]
            expect($0.cellPointer) == 0
         }
      }
      
      internal func testSimpleLoopingRun() async throws {
         // sets cell 2 to 9
         try await with(Interpreter("+++[>+++<-]")) {
            _ = try await $0.run()
            expect($0.tape[1]) == 9
         }
      }
      
      internal func testNestedLoopingRun() async throws {
         // sets cell 3 to 27
         try await with(try Interpreter("+++[>+++[>+++<-]<-]")) {
            _ = try await $0.run()
            expect($0.tape[2]) == 27
         }
      }
      
      internal func testRunWithInput() async throws {
         // outputs the first input character twice, then the
         // second character once
         try await with(try Interpreter(",..,.", input: "hello")) {
            let output = try await $0.run()
            expect(output) == "hhe"
         }
      }
      
      internal func testMultipleRunsWithInput() async throws {
         // outputs the first input character twice, then the
         // second character once
         let interpreter = try Interpreter(",..,.", input: "hello")
         for _ in 1...2 {
            try await with(interpreter) {
               let output = try await $0.run()
               expect(output) == "hhe"
            }
         }
      }
      
      internal func testHelloWorld() async throws {
         // outputs the first input character twice, then the
         // second character once
         let program = ">>>>>+[-->-[>>+>-----<<]<--<---]>-.>>>+.>>..+++[.>]<<<<.+++.------.<<-.>>>>+."
         try await with(try Interpreter(program)) {
            let output = try await $0.run()
            expect(output) == "Hello, World!"
         }
      }
   }
}
