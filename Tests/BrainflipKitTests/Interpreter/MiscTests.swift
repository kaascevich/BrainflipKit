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
    #expect(
      CellValue.min <= UInt32.min,
      """
      minimum cell value should be at least \(UInt32.min)
      """
    )
    #expect(
      CellValue.max >= UInt32.max,
      """
      maximum cell value should be at least \(UInt32.max)
      """
    )
  }

  @Suite("Tape")
  struct TapeTests {
    /// Verifies that the tape is at least 30,000 cells long.
    @Test("Tape length")
    func tapeLength() {
      var interpreter = Interpreter()

      #expect(
        throws: Never.self,
        """
        tape length should be at least 30_000 cells long
        """
      ) {
        try interpreter.handleInstruction(.move(29_999))
      }
    }

    @Test("Negative cell pointers")
    func negativeCellPointers() throws {
      var interpreter = Interpreter()
      try #require(interpreter.state.cellPointer == 0)

      #expect(
        throws: Never.self,
        """
        tape should allow negative cell pointers
        """
      ) {
        try interpreter.handleInstruction(.move(-5))
      }
    }
  }
}
