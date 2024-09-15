// Instruction.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

/// An individual instruction, performing a specific action
/// when executed by an ``Interpreter``.
public enum Instruction: Equatable, Hashable, Sendable {
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
  /// the current cell and writes it to the output
  /// stream. If there is no corresponding Unicode
  /// character, this instruction does nothing.
  case output
  
  /// Takes the next character out of the input iterator
  /// and sets the current cell to that character's
  /// Unicode value. If the cell does not fit the new
  /// value, it remains unchanged.
  case input
  
  // MARK: Non-Core
  
  /// Sets the current cell to a specific value.
  case setTo(CellValue)
  
  /// Multiplies the current cell by `value`, then
  /// adds the result to the cell `offset` cells
  /// away from the current one.
  case multiply(factor: CellValue, offset: Int)
  
  /// Repeatedly moves the cell pointer by the specified
  /// amount until it lands on a zero cell.
  case scan(Int32)
  
  /// Performs an action corresponding to the wrapped
  /// ``ExtraInstruction``, or does nothing if that
  /// instruction is not enabled.
  case extra(ExtraInstruction)
}

public extension Instruction {
  /// All characters that represent Brainflip instructions.
  static let validInstructions = ["+", "-", ">", "<", "[", "]", ",", "."]
    + ExtraInstruction.allCases.map(\.rawValue)
}
