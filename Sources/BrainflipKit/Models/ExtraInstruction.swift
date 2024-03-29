// ExtraInstruction.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

import CasePaths

/// An instruction that can be enabled or disabled
/// per-``Interpreter``.
@CasePathable public enum ExtraInstruction:
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
