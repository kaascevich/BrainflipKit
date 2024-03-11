// PointerMovementTests.swift
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
   final class PointerMovementTests: XCTestCase {
      func testNextCell() throws {
         try with(try Interpreter("")) {
            for i in 1...10 {
               try $0.handleInstruction(.nextCell)
               expect($0.state.cellPointer) == i
            }
         }
      }
      
      func testPrevCell() throws {
         try with(try Interpreter("")) {
            // the cell pointer doesn't support wraparound, so
            // offset ourselves from the beginning by a bit
            $0.state.cellPointer = 10
            
            for i in (0..<10).reversed() {
               try $0.handleInstruction(.prevCell)
               expect($0.state.cellPointer) == i
            }
         }
      }
   }
}
