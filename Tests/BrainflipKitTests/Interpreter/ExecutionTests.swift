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
@testable import BrainflipKit

extension InterpreterTests {
   final class ExecutionTests: XCTestCase {
      func testBasicRun() async throws {
         // increments cell 1 and decrements cell 2
         try await with(try Interpreter<UTF8>("+>-<")) {
            try await $0.run()
            
            expect($0.state.instructionPointer) == $0.program.endIndex
            
            expect($0.state.cells[0..<2]) == [1, Interpreter<UTF8>.CellValue.max]
            expect($0.state.cellPointer) == 0
         }
      }
      
      func testSimpleLoopingRun() async throws {
         // sets cell 2 to 9
         try await with(try Interpreter<UTF8>("+++[>+++<-]")) {
            try await $0.run()
            expect($0.state.cells[1]) == 9
         }
      }
      
      func testNestedLoopingRun() async throws {
         // sets cell 3 to 27
         try await with(try Interpreter<UTF8>("+++[>+++[>+++<-]<-]")) {
            try await $0.run()
            expect($0.state.cells[2]) == 27
         }
      }
      
      func testRunWithInput() async throws {
         // outputs the first input character twice, then the
         // second character once
         try await with(try Interpreter<UTF8>(",..,.", input: "hello")) {
            let output = try await $0.run()
            expect(output) == "hhe"
         }
      }
      
      func testHelloWorld() async throws {
         // outputs the first input character twice, then the
         // second character once
         let program = ">>>>>+[-->-[>>+>-----<<]<--<---]>-.>>>+.>>..+++[.>]<<<<.+++.------.<<-.>>>>+."
         try await with(try Interpreter<UTF8>(program)) {
            let output = try await $0.run()
            expect(output) == "Hello, World!"
         }
      }
   }
}
