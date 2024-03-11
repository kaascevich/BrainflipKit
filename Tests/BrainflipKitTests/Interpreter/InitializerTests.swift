// InitializerTests.swift
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
   final class InitializerTests: XCTestCase {
      func testInitializer() throws {
         with(try Interpreter("")) {
            expect($0.state.cells) == Array(repeating: 0, count: 30000)
            expect($0.state.cellPointer) == 0
            expect($0.state.outputBuffer).to(beEmpty())
            expect($0.input).to(beEmpty())
            expect($0.program).to(beEmpty())
         }
      }
      
      func testUnicodeInput() throws {
         // Unicode value fits in 16 bits
         try with(Interpreter("", input: "→", options: .init(cellSize: 16))) {
            expect($0.input) == "→"
         }
         
         // Unicode value does not fit in 16 bits
         try with(Interpreter("", input: "→")) {
            expect($0.input).to(beEmpty())
         }
      }
   }
}
