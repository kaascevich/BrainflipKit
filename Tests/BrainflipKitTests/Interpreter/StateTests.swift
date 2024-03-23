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
@testable import class BrainflipKit.Interpreter

extension InterpreterTests {
   final class StateTests: XCTestCase {
      func testCurrentCellValue() throws {
         try with(Interpreter("")) {
            $0.cellPointer = 5
            $0.currentCellValue = 42
            expect($0.currentCellValue) == $0.tape[$0.cellPointer]
         }
      }
      
      func testDynamicMemberSubscript() throws {
         try with(Interpreter("")) {
            $0.cellPointer = 5
            $0.currentCellValue = 42
            expect($0.tape[$0.cellPointer]) == $0.tape[$0.cellPointer]
         }
      }
      
      func testDebugDescription() async throws {
         let helloWorldProgram = ">>>>>+[-->-[>>+>-----<<]<--<---]>-.>>>+.>>..+++[.>]<<<<.+++.------.<<-.>>>>+."
         try await with(Interpreter(helloWorldProgram)) {
            _ = try await $0.run()
            
            expect($0.state.debugDescription) == """
            Tape: [0, 72, 0, 153, 100, 172, 108, 44, 33, 87]
            Pointer location: 8 (current cell value: 33)
            
            Output: "Hello, World!"
            """
         }
      }
   }
}
