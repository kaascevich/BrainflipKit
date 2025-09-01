// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation
import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite("State")
  struct StateTests {
    @Test("Current cell value")
    func currentCellValue() throws {
      var interpreter = try Interpreter("")
      interpreter.tape = [0: 237, 1: 29, 2: 74]

      try #require(interpreter.cellPointer == 0)
      #expect(interpreter.currentCellValue == 237)

      interpreter.cellPointer = 1
      #expect(interpreter.currentCellValue == 29)

      interpreter.cellPointer = 2
      #expect(interpreter.currentCellValue == 74)
    }
  }
}
