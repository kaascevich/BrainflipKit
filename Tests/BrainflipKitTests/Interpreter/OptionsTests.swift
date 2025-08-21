// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Interpreter options")
  struct OptionsTests {
    @Test("allowCellWraparound option")
    func allowWraparoundOption() async throws {
      var interpreter = try Interpreter(
        "",
        options: .init(allowCellWraparound: false)
      )

      await #expect(throws: InterpreterError.cellUnderflow(position: 0)) {
        try await interpreter.handleInstruction(.add(-1))
      }

      interpreter.currentCellValue = .max
      await #expect(throws: InterpreterError.cellOverflow(position: 0)) {
        try await interpreter.handleInstruction(.add(1))
      }
    }

    @Suite("End of input behavior options")
    struct EndOfInputBehaviorTests {
      @Test("Do nothing on end of input")
      func doNothingOption() async throws {
        var interpreter = try Interpreter(
          "",
          options: .init(endOfInputBehavior: nil)
        )

        interpreter.currentCellValue = 42
        try await interpreter.handleInstruction(.input)
        #expect(interpreter.currentCellValue == 42)
      }

      @Test("Set the current cell to a value on end of input")
      func setToValueOption() async throws {
        var interpreter = try Interpreter(
          "",
          options: .init(endOfInputBehavior: .setTo(0))
        )

        interpreter.currentCellValue = 42
        try await interpreter.handleInstruction(.input)
        #expect(interpreter.currentCellValue == 0)
      }

      @Test("Throw an error on end of input")
      func throwErrorOption() async throws {
        var interpreter = try Interpreter(
          "",
          options: .init(endOfInputBehavior: .throwError)
        )

        await #expect(throws: InterpreterError.endOfInput) {
          try await interpreter.handleInstruction(.input)
        }
      }
    }
  }
}
