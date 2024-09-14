// Looping.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes a ``Instruction/loop(_:)``.
  ///
  /// - Parameter instructions: The instructions to loop over.
  mutating func handleLoop(_ instructions: [Instruction]) async throws {
    while self.currentCellValue != 0 {
      for instruction in instructions {
        try await handleInstruction(instruction)
        await Task.yield()
      }
    }
  }
}
