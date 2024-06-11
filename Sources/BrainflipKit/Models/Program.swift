// Program.swift
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

/// A list of instructions to be executed by an ``Interpreter``.
public typealias Program = [Instruction]

public extension Program {
   /// Parses the given string into a `Program` instance.
   ///
   /// The following mappings are used to convert a `Character`
   /// into an ``Instruction``:
   ///
   /// | Character |       Instruction        |
   /// |-----------|--------------------------|
   /// |  `+` `-`  | ``Instruction/add(_:)``  |
   /// |  `<` `>`  | ``Instruction/move(_:)`` |
   /// |  `[` `]`  | ``Instruction/loop(_:)`` |
   /// |    `.`    | ``Instruction/output``   |
   /// |    `,`    | ``Instruction/input``    |
   ///
   /// Additionally, the following instructions are also
   /// recognized (although they are disabled by default):
   ///
   /// | Character |           Instruction           | Key Combo |
   /// |-----------|---------------------------------|-----------|
   /// |    `!`    | ``ExtraInstruction/stop``       |           |
   /// |    `~`    | ``ExtraInstruction/bitwiseNot`` |           |
   /// |    `»`    | ``ExtraInstruction/leftShift``  | ⌥ ⇧ \\    |
   /// |    `«`    | ``ExtraInstruction/rightShift`` | ⌥ \\      |
   /// |    `?`    | ``ExtraInstruction/random``     |           |
   ///
   /// All other characters are ignored.
   ///
   /// ## Optimizations
   ///
   /// Some constructs can be simplified to speed up program
   /// execution.
   ///
   /// ### Adjacent Instructions
   /// Repeated occurrences of `+` and `-` are condensed into a
   /// single instruction, as are `>` and `<`. Additionally,
   /// instructions that cancel each other out (such as `+-` or
   /// `><`) are removed.
   ///
   /// ### Instructions With No Effect
   /// Instructions that do not have any effect (such as `add`
   /// or `move` instructions with a value of `0`) are removed.
   ///
   /// ### Clear Loops
   /// The `[-]` construct is replaced with a `setTo(0)`
   /// instruction.
   ///
   /// ### Scan Loops
   /// A `loop` instruction containing only `move` instructions
   /// is replaced with a `scan` instruction.
   ///
   /// ### Dead Code
   /// Loops that occur immediately after other loops are
   /// removed.
   ///
   /// This can be done because, immediately after a loop
   /// finishes, the current cell's value is always 0 (because
   /// that's the end condition for a loop); therefore, an
   /// immediately following loop will never be entered.
   ///
   /// ### Multiply Loops
   ///
   /// This replaces constructs of the following form with
   /// equivalent `multiply(factor, offset)` instructions.
   ///
   /// ```
   /// loop (
   ///   add(-1)
   ///   move(offset)
   ///   add(factor)
   ///   move(-offset)
   /// )
   /// ```
   ///
   /// For example, `[-<<<++>>>]` would be reduced to
   /// `multiply(factor: 2, offset: -3)`.
   ///
   /// - Parameters:
   ///   - source: The original source code for a Brainflip
   ///     program.
   ///   - optimizations: Whether to optimize the program.
   ///
   /// - Throws: An `Error` if `source` is not a valid program
   ///   (that is, if it contains unmatched brackets).
   init(_ source: String, optimizations: Bool = true) async throws {
      self = try Parser(optimizations: optimizations)
         .parse(source.filter(Instruction.validInstructions.contains))
   }
}
