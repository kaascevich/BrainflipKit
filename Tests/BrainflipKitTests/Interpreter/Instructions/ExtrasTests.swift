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
  @Suite("Extra instructions")
  struct ExtrasTests {
    @Test("No instructions enabled")
    func disabledInstructions() async {
      await #expect(
        throws: Never.self,
        "stop insrtuction does nothing when not enabled"
      ) {
        let interpreter = try Interpreter("!")

        // if this throws, then the stop instruction
        // has been executed even though we don't want
        // it to be
        _ = try await interpreter.run()
      }
    }

    @Test("Stop instruction")
    func stopInstruction() async throws {
      var interpreter = try Interpreter(
        "",
        options: .init(enabledExtraInstructions: [.stop])
      )

      await #expect(
        throws: InterpreterError.stopInstruction,
        "stop instruction halts the program by throwing an error"
      ) {
        try await interpreter.handleInstruction(.extra(.stop))
      }
    }

    @Test("Bitwise NOT instruction")
    func bitwiseNotInstruction() async throws {
      var interpreter = try Interpreter(
        "",
        options: .init(enabledExtraInstructions: [.bitwiseNot])
      )

      interpreter.currentCellValue = 42
      try await interpreter.handleInstruction(.extra(.bitwiseNot))
      #expect(
        interpreter.currentCellValue == 4_294_967_253,  // UInt32 bitwise NOT of 42
        "bitwise NOT instruction sets the current cell to its own bitwise NOT"
      )
    }

    @Test("Left shift instruction")
    func leftShiftInstruction() async throws {
      var interpreter = try Interpreter(
        "",
        options: .init(enabledExtraInstructions: [.leftShift])
      )

      interpreter.currentCellValue = 42
      try await interpreter.handleInstruction(.extra(.leftShift))
      #expect(
        interpreter.currentCellValue == 84,  // 42 left-shifted 1
        "left shift instruction left shifts the current cell by 1"
      )
    }

    @Test("Right shift instruction")
    func rightShiftInstruction() async throws {
      var interpreter = try Interpreter(
        "",
        options: .init(enabledExtraInstructions: [.rightShift])
      )

      interpreter.currentCellValue = 42
      try await interpreter.handleInstruction(.extra(.rightShift))
      #expect(
        interpreter.currentCellValue == 21,  // 42 right-shifted 1
        "right shift instruction right shifts the current cell by 1"
      )
    }
  }
}
