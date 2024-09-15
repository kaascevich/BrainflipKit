// Extras.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes the instruction contained within
  /// ``Instruction/extra(_:)``, if it is enabled.
  ///
  /// - Parameter instruction: The instruction to execute.
  /// 
  /// - Throws: ``Error/stopInstruction`` if the instruction is
  ///   ``ExtraInstruction/stop``.
  mutating func handleExtraInstruction(
    _ instruction: ExtraInstruction
  ) throws(Self.Error) {
    guard options.enabledExtraInstructions.contains(instruction) else {
      return
    }
    
    switch instruction {
    // FIXME: this is a fairly simply way to implement this
    // instruction, but it won't let us resume execution if we
    // wanted to add that in the future
    case .stop: throw Error.stopInstruction
    
    case .bitwiseNot: self.currentCellValue = ~self.currentCellValue
      
    case .leftShift:  self.currentCellValue <<= 1
    case .rightShift: self.currentCellValue >>= 1
      
    case .random:
      self.currentCellValue = CellValue.random(in: 0...(.max))
    }
  }
}
