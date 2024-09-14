// Output.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes an ``Instruction/output`` instruction.
  mutating func handleOutputInstruction() {
    // if this cell's value doesn't correspond to a valid
    // Unicode character, do nothing
    guard let unicodeScalar = Unicode.Scalar(self.currentCellValue) else {
      return
    }
    
    let character = Character(unicodeScalar)
    self.outputStream.write(.init(character))
  }
}
