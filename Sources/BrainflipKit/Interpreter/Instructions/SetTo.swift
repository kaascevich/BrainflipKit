// SetTo.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes an ``Instruction/setTo(_:)`` instruction.
  /// 
  /// - Parameter value: The value to set the current cell to.
  mutating func handleSetToInstruction(_ value: CellValue) {
    self.currentCellValue = value
  }
}
