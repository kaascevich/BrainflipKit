// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Represents an error that can happen during the lifetime of an
/// ``Interpreter`` instance.
public enum InterpreterError: Error, Equatable, Hashable {
  /// Indicates that the cell value at the specified `position` overflowed.
  case cellOverflow(position: CellPointer)

  /// Indicates that the cell value at the specified `position` underflowed.
  case cellUnderflow(position: CellPointer)

  /// Indicates that the input iterator was exhausted.
  case endOfInput
}

extension InterpreterError: CustomStringConvertible {
  /// A description of this error.
  public var description: String {
    switch self {
    case .cellOverflow(let position):
      "The cell at position \(position) overflowed."

    case .cellUnderflow(let position):
      "The cell at position \(position) underflowed."

    case .endOfInput:
      "Executed an input instruction after end-of-input was reached."
    }
  }
}
