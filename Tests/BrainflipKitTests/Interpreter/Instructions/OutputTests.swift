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

extension InterpreterTests.InstructionTests {
  @Suite("Output instruction")
  struct OutputTests {
    @Test("Output instruction")
    func outputInstruction() async throws {
      var interpreter = try Interpreter("")

      interpreter.currentCellValue = 0x42 // ASCII code for "B"
      try await interpreter.handleInstruction(.output)
      #expect(interpreter.outputStream as? String == "B")
    }

    @Test("Output instruction with Unicode characters")
    func outputInstruction_unicode() async throws {
      var interpreter = try Interpreter("")

      interpreter.currentCellValue = 0x2192 // Unicode value for "→"
      try await interpreter.handleInstruction(.output)
      #expect(interpreter.outputStream as? String == "→")
    }
  }
}
