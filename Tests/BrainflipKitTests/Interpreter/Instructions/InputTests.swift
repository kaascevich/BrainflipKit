// InputTests.swift
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

extension InterpreterTests.InstructionTests {
   final class InputTests: XCTestCase {
      func testInput() throws {
         try with(try Interpreter("", input: "&")) {
            try $0.handleInstruction(.input)
            expect($0.state.currentCellValue) == 38 // ASCII code for "&" (ampersand)
         }
      }
      
      func testNoInput() throws {
         try with(Interpreter("")) {
            $0.state.currentCellValue = 42 // something other than 0
            try $0.handleInstruction(.input)
            
            expect($0.state.currentCellValue) == 0
         }
      }
   }
}
