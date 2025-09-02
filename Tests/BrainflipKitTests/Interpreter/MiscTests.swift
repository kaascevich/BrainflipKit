// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation
import Testing

@testable import BrainflipKit

extension InterpreterTests {
  /// Tests that the cell type used by the interpreter can store at least every
  /// valid `UInt32`.
  @Test("Cell sizes")
  func cellSizes() {
    var interpreter = Interpreter()

    interpreter.state.currentCellValue = .min
    #expect(interpreter.state.currentCellValue <= UInt32.min)

    interpreter.state.currentCellValue = .max
    #expect(interpreter.state.currentCellValue >= UInt32.max)
  }

  /// Verifies that the tape is at least 30,000 cells long.
  @Test("Tape length")
  func tapeLength() throws {
    var interpreter = Interpreter()
    try interpreter.handleInstruction(.move(30_000))
  }
}
