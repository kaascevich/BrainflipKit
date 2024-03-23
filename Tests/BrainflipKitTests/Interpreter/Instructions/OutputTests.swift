// OutputTests.swift
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
   internal final class OutputTests: XCTestCase {
      internal func testOutput() async throws {
         try await with(Interpreter("")) {
            $0.currentCellValue = 0x42 // ASCII code for "B"
            try await $0.handleInstruction(.output)
            expect($0.outputBuffer) == "B"
         }
      }
      
      internal func testUnicodeOutput() async throws {
         try await with(Interpreter("", options: .init(cellSize: 16))) {
            $0.currentCellValue = 0x2192 // Unicode code unit for "→"
            try await $0.handleInstruction(.output)
            expect($0.outputBuffer) == "→"
         }
      }
   }
}
