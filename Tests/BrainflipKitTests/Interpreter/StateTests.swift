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

import class XCTest.XCTestCase
import Nimble
@testable import BrainflipKit

extension InterpreterTests {
   final class StateTests: XCTestCase {
      func testInitializer() throws {
         with(try Interpreter<UTF8>("")) {
            expect($0.state.cells) == Array(repeating: 0, count: 30000)
            expect($0.state.cellPointer) == 0
            expect($0.state.input).to(beEmpty())
            expect($0.state.output).to(beEmpty())
            expect($0.program).to(beEmpty())
         }
      }
      
      func testCurrentCellValue() throws {
         with(try Interpreter<UTF8>("")) {
            $0.state.cellPointer = 5
            $0.state.currentCellValue = 42
            expect($0.state.currentCellValue) == $0.state.cells[$0.state.cellPointer]
         }
      }
      
      func testCurrentInstruction() throws {
         with(try Interpreter<UTF8>("+>-<")) {
            $0.state.instructionPointer = 2
            expect($0.state.currentInstruction) == .decrement
         }
      }
      
      func testInstructionPointerIsValid() throws {
         with(try Interpreter<UTF8>("+-")) {
            $0.state.instructionPointer = 1
            expect($0.state.instructionPointerIsValid).to(beTrue())
            
            $0.state.instructionPointer = 2
            expect($0.state.instructionPointerIsValid).to(beFalse())
         }
      }
   }
}
