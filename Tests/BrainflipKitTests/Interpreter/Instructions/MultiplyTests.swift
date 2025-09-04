// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension InterpreterTests.InstructionTests {
  @Suite("Mutliply instruction")
  struct MultiplyTests {
    var interpreter = Interpreter(options: .init(allowCellWraparound: false))

    @Test("Multiply instruction")
    mutating func multiplyInstruction() throws {
      interpreter.state.cellPointer = 0
      interpreter.state.tape[0] = 3
      interpreter.state.tape[2] = 5

      try interpreter.handleInstruction(.multiply(factor: 4, offset: 2))

      #expect(
        interpreter.state.tape[2] == 17,  // (3*4) + 5
        """
        multiply instruction should multiply the current cell by the factor \
        and store the result `offset` cells away
        """
      )

      #expect(
        interpreter.state.currentCellValue == 0,
        """
        multiply instruction should set the current cell to 0
        """
      )
    }

    @Test("Multiply overflow (multiplication)")
    mutating func multiplyOverflowMultiplication() throws {
      interpreter.state.cellPointer = 0
      interpreter.state.tape[0] = .max
      interpreter.state.tape[2] = 5

      #expect(
        throws: InterpreterError.cellOverflow(position: 0),
        """
        multiply instruction should throw an error when overflow occurs during \
        multiplication
        """
      ) {
        try interpreter.handleInstruction(.multiply(factor: 4, offset: 2))
      }
    }

    @Test("Multiply overflow (addition)")
    mutating func multiplyOverflowAddition() throws {
      interpreter.state.cellPointer = 0
      interpreter.state.tape[0] = 3
      interpreter.state.tape[2] = .max
      
      #expect(
        throws: InterpreterError.cellOverflow(position: 2),
        """
        multiply instruction should throw an error when overflow occurs during \
        addition
        """
      ) {
        try interpreter.handleInstruction(.multiply(factor: 4, offset: 2))
      }
    }
  }
}
