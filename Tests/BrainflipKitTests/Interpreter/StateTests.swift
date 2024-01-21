// StateTests.swift
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
   final class StateTests: XCTestCase {
      func testInitializer() throws {
         let interpreter = Interpreter([])
         with(interpreter) {
            expect($0.cells) == Array(repeating: 0, count: 30000)
            expect($0.cellPointer) == 0
            expect($0.input).to(beEmpty())
            expect($0.output).to(beEmpty())
            expect($0.program).to(beEmpty())
         }
      }
      
      func testParsingInitializer() throws {
         let interpreter = Interpreter(",[>+<-.]")
         expect(interpreter.program) == [
            .input,
            .loop(.begin),
            .nextCell,
            .increment,
            .prevCell,
            .decrement,
            .output,
            .loop(.end)
         ]
      }
      
      func testCurrentCellValue() throws {
         let interpreter = Interpreter([])
         with(interpreter) {
            $0.cellPointer = 5
            $0.currentCellValue = 42
            expect($0.currentCellValue) == $0.cells[$0.cellPointer]
         }
      }
      
      func testCurrentInstruction() throws {
         let interpreter = Interpreter([.increment, .nextCell, .decrement, .prevCell])
         with(interpreter) {
            $0.instructionPointer = 2
            expect($0.currentInstruction) == .decrement
         }
      }
      
      func testInstructionPointerIsValid() throws {
         let interpreter = Interpreter([.increment, .decrement])
         with(interpreter) {
            $0.instructionPointer = 1
            expect($0.instructionPointerIsValid).to(beTrue())
            
            $0.instructionPointer = 2
            expect($0.instructionPointerIsValid).to(beFalse())
         }
      }
      
      func testNestingLevel() throws {
         let interpreter = Interpreter([])
         with(interpreter) {
            $0.stack = [1, 2, 3]
            expect($0.nestingLevel) == 3
         }
      }
   }
}
