// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import CasePaths

/// An individual instruction, performing a specific action when executed by an
/// ``Interpreter``.
@CasePathable public enum Instruction: Equatable, Hashable, Codable, Sendable {
  /// Increments (or decrements) the current cell by a value.
  ///
  /// The default behavior on overflow is to wrap around.
  case add(CellValue)

  /// Increments (or decrements) the cell pointer by a value.
  case move(CellOffset)

  /// Loops over the contained instructions.
  case loop([Instruction])

  /// Finds the character whose Unicode value equals the current cell and writes
  /// it to the output stream. If there is no corresponding Unicode character,
  /// this instruction does nothing.
  case output

  /// Takes the next character out of the input iterator and sets the current
  /// cell to that character'sUnicode value. If the cell cannot fit the new
  /// value, it remains unchanged.
  case input

  // MARK: Non-Core

  /// For each offset, adds the value times the current cell value to the cell
  /// `offset` cells away from the current cell. Sets the current cell to
  /// `final` once completed.
  case multiply([CellOffset: CellValue], final: CellValue = 0)
}

extension Instruction {
  /// All characters that represent Brainflip instructions.
  public static let validInstructions: [Character] = [
    "+", "-", ">", "<", "[", "]", ",", ".",
  ]
}

extension Instruction {
  public static func setTo(_ value: CellValue) -> Self {
    .multiply([:], final: value)
  }
}
