// Error.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

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
