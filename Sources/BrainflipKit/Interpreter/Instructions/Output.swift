// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/output`` instruction.
  mutating func handleOutputInstruction() {
    // if this cell's value doesn't correspond to a valid Unicode character, do
    // nothing
    guard
      let codePoint = UInt32(exactly: self.currentCellValue),
      let scalar = Unicode.Scalar(codePoint)
    else {
      return
    }

    self.outputStream.write(String(scalar))
  }
}
