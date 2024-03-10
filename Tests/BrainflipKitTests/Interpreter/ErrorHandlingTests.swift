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

import class XCTest.XCTestCase
import Nimble
@testable import BrainflipKit

extension InterpreterTests {
   final class ErrorHandlingTests: XCTestCase {
      // MARK: - Input
      
      func testNoInput() throws {
         try with(Interpreter<UTF8>([], input: "")) {
            $0.state.currentCellValue = 42 // something other than 0
            try $0.handleInstruction(.input)
            
            expect($0.state.currentCellValue) == 0
         }
      }
   }
}
