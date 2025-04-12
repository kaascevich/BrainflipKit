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
  /// Executes the instruction contained within ``Instruction/extra(_:)``, if it
  /// is enabled.
  ///
  /// - Parameter instruction: The instruction to execute.
  ///
  /// - Throws: ``Error/stopInstruction`` if the instruction is
  ///   ``ExtraInstruction/stop``.
  mutating func handleExtraInstruction(
    _ instruction: ExtraInstruction,
  ) throws(InterpreterError) {
    guard options.enabledExtraInstructions.contains(instruction) else {
      return
    }

    switch instruction {
    // TODO: this is a fairly simply way to implement this instruction, but it
    // won't let us resume execution if we wanted to add that in the future
    case .stop: throw .stopInstruction

    case .bitwiseNot: self.currentCellValue = ~self.currentCellValue

    case .leftShift: self.currentCellValue <<= 1
    case .rightShift: self.currentCellValue >>= 1

    case .random:
      self.currentCellValue = CellValue.random(in: 0...(.max))
    }
  }
}
