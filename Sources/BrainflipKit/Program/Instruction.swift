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

/// An individual instruction, performing a specific action
/// when executed by an ``Interpreter``.
public enum Instruction: Hashable {
   /// Increments ``Interpreter/State/currentCellValue``.
   ///
   /// The default behavior on overflow is to wrap around,
   /// setting the cell to 0.
   case increment
   
   /// Decrements ``Interpreter/State/currentCellValue``.
   ///
   /// The default behavior on underflow is to wrap around,
   /// setting the cell to its maximum value.
   case decrement
   
   /// Increments ``Interpreter/State/cellPointer`` by 1.
   case nextCell
   
   /// Decrements ``Interpreter/State/cellPointer`` by 1.
   case prevCell
   
   /// Loops over the contained instructions.
   case loop([Self])
   
   /// Finds the character whose ASCII value equals
   /// ``Interpreter/State/currentCellValue`` and
   /// appends it to the output buffer.
   case output
   
   /// Takes the next character out of the input buffer
   /// and sets ``Interpreter/State/currentCellValue``
   /// to that character's ASCII value.
   case input
}
