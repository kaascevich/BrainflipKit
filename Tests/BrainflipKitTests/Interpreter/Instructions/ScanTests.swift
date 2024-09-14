// ScanTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests.InstructionTests {
  @Suite("Scan instruction")
  struct ScanTests {
    @Test("Scan instruction")
    func scanInstruction() async throws {
      var interpreter = try Interpreter("")
      
      interpreter.tape = [
        0: 1,
        1: 2,
        2: 3,
        3: 0, // this cell is zero, but at an odd index
        4: 5,
        5: 6,
        6: 0, // this cell is zero, and at an even index
      ]
      
      try await interpreter.handleInstruction(.scan(2))
      #expect(
        interpreter.cellPointer == 6,
        """
        scan instruction repeatedly moves the cell pointer by the \
        specified amount until it lands on a zero cell
        """
      )
    }
  }
}
