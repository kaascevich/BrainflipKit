// EncodingTests.swift
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
   final class EncodingTests: XCTestCase {
      func testUTF8() async throws {
         try await with(try Interpreter<UTF8>("-")) {
            try await $0.run()
            expect($0.state.currentCellValue) == 255
         }
      }
      
      func testUTF16() async throws {
         try await with(try Interpreter<UTF16>("-")) {
            try await $0.run()
            expect($0.state.currentCellValue) == 65_535
         }
      }
      
      func testUTF32() async throws {
         try await with(try Interpreter<UTF32>("-")) {
            try await $0.run()
            expect($0.state.currentCellValue) == 4_294_967_295
         }
      }
   }
}
