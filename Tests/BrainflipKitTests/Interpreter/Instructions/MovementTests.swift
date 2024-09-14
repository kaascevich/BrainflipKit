// MovementTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests.InstructionTests {
  @Suite("Move instruction")
  struct MovementTests {
    @Test("Move instruction")
    func moveRightInstruction() async throws {
      var interpreter = try await Interpreter("")
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
