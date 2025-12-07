// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation
import Testing

@testable import BrainflipKit

extension InterpreterTests {
  @Suite struct `Tape` {
    /// The tape is at least 30,000 cells long.
    @Test func `Tape length`() async {
      await #expect(processExitsWith: .success) {
        var interpreter = Interpreter()
        interpreter.handleInstruction(.move(29_999))
      }
    }

    /// The tape allows negative cell pointers.
    @Test func `Negative cell pointers`() async throws {
      await #expect(processExitsWith: .success) {
        var interpreter = Interpreter()
        try #require(interpreter.state.cellPointer == 0)

        interpreter.handleInstruction(.move(-5))
      }
    }
  }

  /// The cell type used by the interpreter can store at least every valid
  /// `UInt32`.
  @Test func `Cell sizes`() {
    #expect(
      CellValue.min <= UInt32.min,
      "minimum cell value is at most \(UInt32.min)"
    )
    #expect(
      CellValue.max >= UInt32.max,
      "maximum cell value is at least \(UInt32.max)"
    )
  }
}
