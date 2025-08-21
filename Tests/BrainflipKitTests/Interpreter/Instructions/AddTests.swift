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
  @Suite("Add instruction")
  struct AddTests {
    var interpreter: Interpreter
    init() throws {
      self.interpreter = try .init("")
    }

    @Test("Add instruction")
    mutating func addInstruction() async throws {
      for i in 1...500 {
        try await interpreter.handleInstruction(.add(1))
        #expect(interpreter.tape.first?.value == CellValue(i))
      }

      interpreter.currentCellValue = .max
      try await interpreter.handleInstruction(.add(1))
      #expect(
        interpreter.tape.first?.value == 0,
        "increment instruction should wrap around"
      )
    }

    @Test("Add instruction - negative")
    mutating func addInstructionNegative() async throws {
      try await interpreter.handleInstruction(.add(-1))
      #expect(
        interpreter.tape.first?.value == .max,
        "decrement instruction should wrap around"
      )

      interpreter.currentCellValue = 500
      for i in (0..<500).reversed() {
        try await interpreter.handleInstruction(.add(-1))
        #expect(interpreter.tape.first?.value == CellValue(i))
      }
    }
  }
}
