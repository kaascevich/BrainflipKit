// OptionsTests.swift
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
   final class OptionsTests: XCTestCase {
      func testCellSize() throws {
         try with(try Interpreter("", options: .init(
            cellSize: 16
         ))) {
            expect($0.options.cellMax) == 65_535
            
            try $0.handleInstruction(.decrement)
            expect($0.state.cells[0]) == 65_535
         }
      }
      
      func testArraySize() throws {
         with(try Interpreter("", options: .init(
            arraySize: 20
         ))) {
            expect($0.state.cells.count) == 20
         }
      }
      
      func testInitialPointerLocation() throws {
         with(try Interpreter("", options: .init(
            initialPointerLocation: 5
         ))) {
            expect($0.state.cellPointer) == 5
         }
      }
      
      func testAllowWraparound() throws {
         try with(try Interpreter("", options: .init(
            allowCellWraparound: false
         ))) {
            expect(try $0.handleInstruction(.decrement))
               .to(throwError(Interpreter.Error.cellUnderflow))
            
            $0.state.currentCellValue = 255
            expect(try $0.handleInstruction(.increment))
               .to(throwError(Interpreter.Error.cellOverflow))
         }
      }
   }
}
