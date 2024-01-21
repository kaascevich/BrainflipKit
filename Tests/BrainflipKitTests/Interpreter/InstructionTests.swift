// InstructionTests.swift
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
   final class InstructionTests: XCTestCase {
      // MARK: - State
      
      var interpreter = Interpreter([])
      
      // MARK: - Setup
      override func setUp() async throws {
         interpreter = .init([])
      }
      
      // MARK: - Tests
      
      func testIncrement() throws {
         try with(interpreter) {
            for i in 1...Interpreter.Cell.max {
               try $0.handleInstruction(.increment)
               expect($0.cells.first) == i
            }
            
            try $0.handleInstruction(.increment)
            expect($0.cells.first) == 0
         }
      }
         
      func testDecrement() throws {
         try with(interpreter) {
            try $0.handleInstruction(.decrement)
            expect($0.cells.first) == Interpreter.Cell.max
            
            for i in (0..<Interpreter.Cell.max).reversed() {
               try $0.handleInstruction(.decrement)
               expect($0.cells.first) == i
            }
         }
      }
      
      func testNextCell() throws {
         try with(interpreter) {
            for i in 1...10 {
               try $0.handleInstruction(.nextCell)
               expect($0.cellPointer) == i
            }
         }
      }
      
      func testPrevCell() throws {
         try with(interpreter) {
            // the cell pointer doesn't support wraparound, so
            // offset ourselves from the beginning by a bit
            $0.cellPointer = 10
            
            for i in (0..<10).reversed() {
               try $0.handleInstruction(.prevCell)
               expect($0.cellPointer) == i
            }
         }
      }
      
      func testOutput() throws {
         try with(interpreter) {
            $0.currentCellValue = 66 // ASCII code for "B"
            try $0.handleInstruction(.output)
            expect($0.output) == "B"
         }
      }
      
      func testInput() throws {
         try with(interpreter) {
            $0.input = "&"
            try $0.handleInstruction(.input)
            expect($0.currentCellValue) == 38 // ASCII code for "&" (ampersand)
         }
      }
   }
}
