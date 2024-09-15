// Looping.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

extension Interpreter {
  /// Executes a ``Instruction/loop(_:)``.
  ///
  /// - Parameter instructions: The instructions to loop over.
  ///
  /// - Throws: An ``Error`` if an error occurs while executing the
  ///   instructions.
  mutating func handleLoop(_ instructions: [Instruction]) async throws(Self.Error) {
    while self.currentCellValue != 0 {
      try await execute(instructions)
    }
  }
}
