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
   /// | Character |          Instruction          |
   /// |-----------|-------------------------------|
   /// |    `+`    | ``Instruction/increment(_:)`` |
   /// |    `-`    | ``Instruction/decrement(_:)`` |
   /// |    `>`    | ``Instruction/moveRight(_:)`` |
   /// |    `<`    | ``Instruction/moveLeft(_:)``  |
   /// |  `[` `]`  | ``Instruction/loop(_:)``      |
   /// |    `.`    | ``Instruction/output``        |
   /// |    `,`    | ``Instruction/input``         |
   ///
   /// Additionally, the following instructions are also
   /// recognized (although they are disabled by default):
   ///
   /// | Character |           Instruction           |
   /// |-----------|---------------------------------|
   /// |    `!`    | ``ExtraInstruction/stop``       |
   /// |    `0`    | ``ExtraInstruction/zero``       |
   /// |    `~`    | ``ExtraInstruction/bitwiseNot`` |
   /// |    `{`    | ``ExtraInstruction/leftShift``  |
   /// |    `}`    | ``ExtraInstruction/rightShift`` |
   /// |    `?`    | ``ExtraInstruction/random``     |
   ///
   /// All other characters are parsed into ``Instruction/comment(_:)``
   /// instructions, which are ignored during execution.
   ///
   /// ## Optimization
   ///
   /// Some constructs can be simplified to speed up program
   /// execution. The tricks currently used to optimize programs
   /// are:
   ///
   /// - Repeated occurrences of `+`, `-`, `>`, or `<` are
   ///   condensed into a single instruction.
   /// - The `[-]++`...`++` construct is replaced with a `setTo(n)`
   ///   instruction, where *n* is the number of `+` instructions
   ///   that follow `[-]`.
   ///
   /// - Parameter string: A string to parse into a `Program`.
   ///
   /// - Throws: An `Error` if `string` is not a valid program
   ///   (that is, if it contains unmatched brackets).
   init(_ string: String) throws {
      self = try BrainflipParser.parse(program: string)
   }
}

public extension Program {
   var description: String {
      BrainflipParser.print(program: self)
   }
}
