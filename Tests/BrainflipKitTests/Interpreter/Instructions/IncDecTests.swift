// IncDecTests.swift
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
   internal final class IncDecTests: XCTestCase {
      internal func testIncrement() async throws {
         try await with(Interpreter("")) {
            for i in 1...$0.options.cellMax {
               try await $0.handleInstruction(.increment)
               expect($0.tape.first) == i
            }
            
            try await $0.handleInstruction(.increment)
            expect($0.tape.first) == 0
         }
      }
         
      internal func testDecrement() async throws {
         try await with(Interpreter("")) {
            try await $0.handleInstruction(.decrement)
            expect($0.tape.first) == $0.options.cellMax
            
            for i in (0..<$0.options.cellMax).reversed() {
               try await $0.handleInstruction(.decrement)
               expect($0.tape.first) == i
            }
         }
      }
   }
}
