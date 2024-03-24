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
@testable import class BrainflipKit.Interpreter

extension InterpreterTests {
   internal final class OptionsTests: XCTestCase {
      internal func testCellSize() async throws {
         try await with(Interpreter("", options: .init(cellSize: 16))) {
            expect($0.options.cellMax) == 65_535
            
            try await $0.handleInstruction(.decrement)
            expect($0.tape[0]) == 65_535
         }
         
         // out-of-bounds cell size
         expect(Interpreter.Options(cellSize: 72))
            .to(throwAssertion())
      }
      
      internal func testAllowWraparound() async throws {
         try await with(Interpreter("", options: .init(allowCellWraparound: false))) {
            await expecta(try await $0.handleInstruction(.decrement))
               .to(throwError(Interpreter.Error.cellUnderflow))
            
            $0.currentCellValue = 255
            await expecta(try await $0.handleInstruction(.increment))
               .to(throwError(Interpreter.Error.cellOverflow))
         }
      }
      
      internal func testEndOfInputBehavior() async throws {
         try await with(Interpreter("", options: .init(endOfInputBehavior: nil))) {
            $0.currentCellValue = 42
            try await $0.handleInstruction(.input)
            expect($0.currentCellValue) == 42
         }
         
         try await with(Interpreter("", options: .init(endOfInputBehavior: .setTo(0)))) {
            $0.currentCellValue = 42
            try await $0.handleInstruction(.input)
            expect($0.currentCellValue) == 0
         }
         
         try await with(Interpreter("", options: .init(endOfInputBehavior: .setTo(.max)))) {
            $0.currentCellValue = 42
            try await $0.handleInstruction(.input)
            expect($0.currentCellValue) == 255
         }
         
         try await with(Interpreter("", options: .init(endOfInputBehavior: .throwError))) {
            await expecta(try await $0.handleInstruction(.input))
               .to(throwError(Interpreter.Error.endOfInput))
         }
      }
   }
}
