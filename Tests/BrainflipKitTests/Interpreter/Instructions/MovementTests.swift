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
  @Suite("Move instruction")
  struct MovementTests {
    @Test("Move instruction")
    func moveRightInstruction() async throws {
      var interpreter = try Interpreter("")
      for i in 1...10 {
        try await interpreter.handleInstruction(.move(1))
        #expect(interpreter.cellPointer == i)
      }

      for i in (0..<10).reversed() {
        try await interpreter.handleInstruction(.move(-1))
        #expect(interpreter.cellPointer == i)
      }
    }
  }
}
