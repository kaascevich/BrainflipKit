// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

/// Represents an error that can happen during the
/// lifetime of an ``Interpreter`` instance.
public enum InterpreterError: Error, Equatable, Hashable {
  /// Indicates that the cell value at the specified
  /// `position` overflowed.
  case cellOverflow(position: Int)

  /// Indicates that the cell value at the specified
  /// `position` underflowed.
  case cellUnderflow(position: Int)

  /// Indicates that the input iterator was exhausted.
  case endOfInput

  /// Indicates that the program was ended by a
  /// ``ExtraInstruction/stop`` instruction.
  case stopInstruction
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

    case .stopInstruction:
      "Encountered a stop instruction."
    }
  }
}
