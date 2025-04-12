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
  @Suite("Mutliply instruction")
  struct MultiplyTestsTests {
    @Test("Multiply instruction")
    func multiplyInstruction() async throws {
      var interpreter = try Interpreter("")

      interpreter.currentCellValue = 3
      interpreter.tape[2] = 5
      try await interpreter.handleInstruction(
        .multiply(factor: 4, offset: 2),
      )
      #expect(interpreter.tape[2] == 17)  // (3*4) + 5
      #expect(interpreter.currentCellValue == 0)
    }
  }
}
