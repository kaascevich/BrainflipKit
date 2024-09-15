// Input.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

extension Interpreter {
  /// Executes an ``Instruction/input`` instruction.
  /// 
  /// - Throws: ``Error/endOfInput`` if the input iterator is empty
  ///   and ``Options/endOfInputBehavior`` is set to
  ///   ``Options/EndOfInputBehavior/throwError``.
  mutating func handleInputInstruction() throws(Self.Error) {
    // make sure we actually have some input to work with
    guard let nextInputScalar = self.inputIterator.next() else {
      switch options.endOfInputBehavior {
      case .setTo(let value): self.currentCellValue = value
      case .throwError: throw Error.endOfInput
      case nil: break
      }
      
      return
    }
    
    self.currentCellValue = nextInputScalar.value
  }
}
