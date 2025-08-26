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
    var interpreter: Interpreter<String.UnicodeScalarView, String>
    init() throws {
      self.interpreter = try .init("")
    }

    @Test("Output instruction")
    mutating func outputInstruction() async throws {
      interpreter.currentCellValue = 0x42  // ASCII code for "B"
      try await interpreter.handleInstruction(.output)
      #expect(interpreter.outputStream == "B")
    }

    @Test("Output instruction with Unicode characters")
    mutating func outputInstructionUnicode() async throws {
      interpreter.currentCellValue = 0x2192  // Unicode value for "→"
      try await interpreter.handleInstruction(.output)
      #expect(interpreter.outputStream == "→")
    }

    @Test("Output instruction with invalid Unicode characters")
    mutating func outputInstructionInvalidUnicode() async throws {
      interpreter.currentCellValue = 0x110000  // max Unicode value is 0x10FFFF
      try await interpreter.handleInstruction(.output)
      #expect(interpreter.outputStream.isEmpty)
    }
  }
}
