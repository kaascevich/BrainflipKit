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
  /// Executes an ``Instruction/scan(_:)`` instruction.
  ///
  /// - Parameter increment: The value to increment the cell
  ///   pointer by on each iteration.
  mutating func handleScanInstruction(_ increment: Int32) {
    while self.currentCellValue != 0 {
      self.cellPointer += Int(increment)
    }
  }
}
