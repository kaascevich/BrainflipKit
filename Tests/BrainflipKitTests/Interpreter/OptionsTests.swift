// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("Interpreter options") struct OptionsTests {
    @Test("allowCellWraparound option")
    func allowWraparoundOption() throws {
      var interpreter = try Interpreter(
        "",
        options: .init(allowCellWraparound: false)
      )

      interpreter.currentCellValue = .min
      #expect(throws: InterpreterError.cellUnderflow(position: 0)) {
        try interpreter.handleInstruction(.add(-1))
      }

      interpreter.currentCellValue = .max
      #expect(throws: InterpreterError.cellOverflow(position: 0)) {
        try interpreter.handleInstruction(.add(1))
      }
    }

    @Suite("End of input behavior options") struct EndOfInputBehaviorTests {
      @Test("Do nothing on end of input")
      func doNothingOption() throws {
        var interpreter = try Interpreter(
          "",
          options: .init(endOfInputBehavior: nil)
        )

        interpreter.currentCellValue = 42
        try interpreter.handleInstruction(.input)
        #expect(interpreter.currentCellValue == 42)
      }

      @Test("Set the current cell to a value on end of input")
      func setToValueOption() throws {
        var interpreter = try Interpreter(
          "",
          options: .init(endOfInputBehavior: .setTo(0))
        )

        interpreter.currentCellValue = 42
        try interpreter.handleInstruction(.input)
        #expect(interpreter.currentCellValue == 0)
      }

      @Test("Throw an error on end of input")
      func throwErrorOption() throws {
        var interpreter = try Interpreter(
          "",
          options: .init(endOfInputBehavior: .throwError)
        )

        #expect(throws: InterpreterError.endOfInput) {
          try interpreter.handleInstruction(.input)
        }
      }
    }
  }
}
