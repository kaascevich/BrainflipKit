// ErrorHandlingTests.swift
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
   final class ErrorHandlingTests: XCTestCase {
      // MARK: - State
      
      var interpreter = Interpreter([])
      
      // MARK: - Setup
      override func setUp() async throws {
         interpreter = .init([])
      }
      
      // MARK: - Input
      
      func testInvalidInput() throws {
         expect {
            try with(self.interpreter) {
               $0.input = "™" // not an ASCII character
               try $0.handleInstruction(.input)
            }
         }.to(throwError(Interpreter.Error.illegalCharacterInInput("™")))
      }
      
      func testNoInput() throws {
         try with(interpreter) {
            $0.currentCellValue = 42 // something other than 0
            $0.input = ""
            try $0.handleInstruction(.input)
            
            expect($0.currentCellValue) == 0
         }
      }
      
      func testMismatchedBrackets() async throws {
         await expect {
            let interpreter = Interpreter([.loop(.end)])
            try await interpreter.run()
         }.to(throwError(Interpreter.Error.unpairedLoopInstruction(.end)))
         
         await expect {
            let interpreter = Interpreter([.loop(.begin)])
            try await interpreter.run()
         }.to(throwError(Interpreter.Error.unpairedLoopInstruction(.begin)))
      }
      
      func testNoMoreInstructions() throws {
         let interpreter = Interpreter([.increment, .decrement])
         try with(interpreter) {
            expect(try $0.step()) // ip == 0
               .toNot(throwError())
            
            expect(try $0.step()) // ip == 1
               .toNot(throwError())
            
            expect(try $0.step()) // ip == 2
               .to(throwError(Interpreter.Error.noInstructionsRemaining))
         }
      }
   }
}
