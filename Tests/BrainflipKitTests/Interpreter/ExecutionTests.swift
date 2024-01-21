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

import XCTest
import Nimble
@testable import BrainflipKit

extension InterpreterTests {
   final class ExecutionTests: XCTestCase {
      func testBasicRun() async throws {
         // Equivalent to "+>-<". Increments cell 1
         // and decrements cell 2.
         let interpreter = Interpreter([.increment, .nextCell, .decrement, .prevCell])
         try await with(interpreter) {
            try await $0.run()
            
            expect($0.instructionPointer) == $0.program.endIndex
            
            expect($0.cells[0..<2]) == [1, Interpreter.Cell.max]
            expect($0.cellPointer) == 0
         }
      }
      
      func testSimpleLoopingRun() async throws {
         // Equivalent to "+++[>+++<-]". This sets
         // cell 2 to 9.
         let interpreter = Interpreter([
            .increment, .increment, .increment,
            .loop(.begin),
            .nextCell, .increment, .increment, .increment,
            .prevCell, .decrement,
            .loop(.end)
         ])
         try await with(interpreter) {
            try await $0.run()
            expect($0.cells[1]) == 9
         }
      }
      
      func testNestedLoopingRun() async throws {
         // Equivalent to "+++[>+++[>+++<-]<-]".
         // This sets cell 3 to 27.
         let interpreter = Interpreter([
            .increment, .increment, .increment,
            .loop(.begin),
            .nextCell, .increment, .increment, .increment,
            .loop(.begin),
            .nextCell, .increment, .increment, .increment,
            .prevCell, .decrement,
            .loop(.end),
            .prevCell, .decrement,
            .loop(.end)
         ])
         try await with(interpreter) {
            try await $0.run()
            expect($0.cells[2]) == 27
         }
      }
      
      func testRunWithInput() async throws {
         // Equivalent to ",..,.". Outputs the first input
         // character twice, then the second character
         // once.
         let interpreter = Interpreter([.input, .output, .output, .input, .output])
         try await with(interpreter) {
            let output = try await $0.run(input: "hello")
            expect(output) == "hhe"
         }
      }
   }
}
