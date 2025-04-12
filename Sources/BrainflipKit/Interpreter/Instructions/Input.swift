// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

extension Interpreter {
  /// Executes an ``Instruction/input`` instruction.
  ///
  /// - Throws: ``Error/endOfInput`` if the input iterator is empty and
  ///   ``Options/endOfInputBehavior`` is set to
  ///   ``Options/EndOfInputBehavior/throwError``.
  mutating func handleInputInstruction() throws(InterpreterError) {
    // make sure we actually have some input to work with
    guard let nextInputScalar = self.inputIterator.next() else {
      switch options.endOfInputBehavior {
      case .setTo(let value): self.currentCellValue = value
      case .throwError: throw .endOfInput
      case nil: break
      }

      return
    }

    self.currentCellValue = nextInputScalar.value
  }
}
