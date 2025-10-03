// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

public import CasePaths

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
  /// cell to that character's Unicode value. If the cell cannot fit the new
  /// value, it remains unchanged.
  case input

  // MARK: Non-Core

  /// For each offset, adds the value times the current cell value to the cell
  /// `offset` cells away from the current cell. Sets the current cell to
  /// `final` once completed.
  case multiply([CellOffset: CellValue], final: CellValue = 0)

  /// Sets the current cell to `value`.
  public static func setTo(_ value: CellValue) -> Self {
    .multiply([:], final: value)
  }
}

// MARK: Debugging

extension Instruction: CustomReflectable {
  /// The custom mirror for this instance.
  public var customMirror: Mirror {
    let children: KeyValuePairs<String, Any> =
      switch self {
      case .add(let value):
        ["add": value]

      case .move(let offset):
        ["move": offset]

      case .output, .input:
        [:]

      case .loop(let instructions):
        ["loop": instructions]

      case .multiply([:], let final):
        ["setTo": final]

      case .multiply(let multiplications, final: 0):
        ["multiply": multiplications]

      case .multiply(let multiplications, let final):
        ["multiply": (multiplications, final: final)]
      }

    return Mirror(self, children: children, displayStyle: .enum)
  }
}
