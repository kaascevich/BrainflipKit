// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/output`` instruction.
  mutating func handleOutputInstruction() {
    // if this cell's value doesn't correspond to a valid Unicode character, do
    // nothing
    guard let unicodeScalar = Unicode.Scalar(self.currentCellValue) else {
      return
    }

    let character = Character(unicodeScalar)
    self.outputStream.write(String(character))
  }
}
