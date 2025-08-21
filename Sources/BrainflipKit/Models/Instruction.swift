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

import CasePaths

/// An individual instruction, performing a specific action when executed by an
/// ``Interpreter``.
@CasePathable public enum Instruction: Equatable, Hashable, Sendable {
  /// Increments (or decrements) the current cell by a value.
  ///
  /// The default behavior on overflow is to wrap around.
  case add(Int32)

  /// Increments (or decrements) the cell pointer by a value.
  case move(Int32)

  /// Loops over the contained instructions.
  case loop([Self])

  /// Finds the character whose Unicode value equals the current cell and writes
  /// it to the output stream. If there is no corresponding Unicode character,
  /// this instruction does nothing.
  case output

  /// Takes the next character out of the input iterator and sets the current
  /// cell to that character'sUnicode value. If the cell cannot fit the new
  /// value, it remains unchanged.
  case input

  // MARK: Non-Core

  /// Sets the current cell to a specific value.
  case setTo(CellValue)

  /// Multiplies the current cell by `value`, then adds the result to the cell
  /// `offset` cells away from the current one.
  case multiply(factor: CellValue, offset: Int)

  /// Repeatedly moves the cell pointer by the specified amount until it lands
  /// on a zero cell.
  case scan(Int32)

  /// Performs an action corresponding to the wrapped ``ExtraInstruction``, or
  /// does nothing if that instruction is not enabled.
  case extra(ExtraInstruction)
}

extension Instruction {
  /// All characters that represent Brainflip instructions.
  public static let validInstructions =
    ["+", "-", ">", "<", "[", "]", ",", "."]
    + ExtraInstruction.allCases.map(\.rawValue)
}
