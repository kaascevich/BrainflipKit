// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

extension Interpreter {
  /// Executes a ``Instruction/loop(_:)``.
  ///
  /// - Parameter instructions: The instructions to loop over.
  ///
  /// - Throws: An ``Error`` if an error occurs while executing the
  ///   instructions.
  mutating func handleLoop(_ instructions: [Instruction]) async throws(InterpreterError) {
    while self.currentCellValue != 0 {
      try await execute(instructions)
    }
  }
}
