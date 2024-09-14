// Scan.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes an ``Instruction/scan(_:)`` instruction.
  mutating func handleScanInstruction(_ increment: Int32) {
    while self.currentCellValue != 0 {
      self.cellPointer += Int(increment)
    }
  }
}
