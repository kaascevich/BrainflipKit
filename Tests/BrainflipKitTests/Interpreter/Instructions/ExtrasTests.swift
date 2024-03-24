// ExtrasTests.swift
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
   internal final class ExtrasTests: XCTestCase {
      internal func testNone() async throws {
         try await with(Interpreter("!")) {
            try await $0.run()
            // nothing should happen
         }
      }
      
      internal func testStop() async throws {
         let options = Interpreter.Options(enabledExtraInstructions: [.stop])
         try await with(Interpreter("", options: options)) {
            await expecta(try await $0.handleInstruction(.extra(.stop)))
               .to(throwError(Interpreter.Error.stopInstruction))
         }
      }
   }
}
