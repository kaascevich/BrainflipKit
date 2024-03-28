// Instruction.swift
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

/// An individual instruction, performing a specific action
/// when executed by an ``Interpreter``.
@CasePathable public enum Instruction: Equatable, Hashable, Sendable {
   /// Increments (or decrements) the current cell by a
   /// value.
   ///
   /// The default behavior on overflow is to wrap around.
   case add(Int32)
   
   /// Increments (or decrements) the cell pointer by
   /// a value.
   case move(Int32)
   
   /// Loops over the contained instructions.
   case loop([Self])
   
   /// Finds the character whose Unicode value equals
   /// the current cell and appends it to the output
   /// buffer. If there is no corresponding Unicode
   /// character, this instruction does nothing.
   case output
   
   /// Takes the next character out of the input buffer
   /// and sets the current cell to that character's
   /// Unicode value. If the cell does not fit the new
   /// value, it remains unchanged.
   case input
   
   // MARK: Non-Core
   
   /// Sets the current cell to a specific value.
   case setTo(Interpreter.CellValue)
   
   /// Moves the pointer to the next zero cell.
   case scanRight
   
   /// Moves the pointer to the previous zero cell.
   case scanLeft
   
   /// Performs an action corresponding to the wrapped
   /// ``ExtraInstruction``, or does nothing if that
   /// instruction is not enabled.
   case extra(ExtraInstruction)
}
