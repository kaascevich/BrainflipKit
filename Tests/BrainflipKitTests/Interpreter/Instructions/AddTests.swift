// AddTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import struct BrainflipKit.Interpreter

extension InterpreterTests.InstructionTests {
  @Suite("Add instruction")
  struct AddTests {
    @Test("Add instruction")
    func addInstruction() async throws {
      var interpreter = try await Interpreter("")
      
      for i in 1...500 {
        try await interpreter.handleInstruction(.add(1))
        #expect(interpreter.tape.first?.value == UInt32(i))
      }
      
      interpreter.currentCellValue = .max
      try await interpreter.handleInstruction(.add(1))
      #expect(
        interpreter.tape.first?.value == .min,
        "increment instruction should wrap around"
      )
    }
      
    @Test("Add instruction - negative")
    func addInstruction_negative() async throws {
      var interpreter = try await Interpreter("")
      
      try await interpreter.handleInstruction(.add(-1))
      #expect(
        interpreter.tape.first?.value == .max,
        "decrement instruction should wrap around"
      )
      
      interpreter.currentCellValue = 500
      for i in (0..<500).reversed() {
        try await interpreter.handleInstruction(.add(-1))
        #expect(interpreter.tape.first?.value == UInt32(i))
      }
    }
  }
}
