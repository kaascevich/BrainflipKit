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

import Testing
@testable import class BrainflipKit.Interpreter

extension InterpreterTests {
   @Suite("Interpreter state")
   struct StateTests {
      var interpreter: Interpreter
      init() throws {
         interpreter = try Interpreter("")
      }
      
      @Test("currentCellValue property")
      func currentCellValue() throws {
         interpreter.cellPointer = 5
         interpreter.currentCellValue = 42
         #expect(interpreter.currentCellValue == interpreter.tape[interpreter.cellPointer])
      }
      
      @Test("Dynamic member lookup")
      func dynamicMemberSubscript() throws {
         interpreter.cellPointer = 5
         interpreter.currentCellValue = 42
         #expect(interpreter.currentCellValue == interpreter.state.currentCellValue)
      }
   }
}
