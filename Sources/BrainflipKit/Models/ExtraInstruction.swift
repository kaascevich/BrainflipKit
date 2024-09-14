// ExtraInstruction.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

/// An instruction that can be enabled or disabled
/// per-``Interpreter``.
public enum ExtraInstruction:
  Character, Equatable, Hashable, CaseIterable, Sendable {
  /// Immediately ends the program.
  case stop = "!"
  
  /// Performs a bitwise NOT on the current cell.
  case bitwiseNot = "~"
  
  /// Performs a lossy left bit-shift on the current cell.
  case leftShift = "«"
  
  /// Performs a lossy right bit-shift on the current cell.
  case rightShift = "»"
  
  /// Sets the current cell to a random value.
  case random = "?"
}
