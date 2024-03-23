// Parser.swift
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

import Parsing

internal enum BrainflipParser {
   private struct InstructionParser: ParserPrinter {
      var body: some ParserPrinter<Substring, Instruction> {
         OneOf {
            "+".map(.case(Instruction.increment))
            "-".map(.case(Instruction.decrement))
            ">".map(.case(Instruction.nextCell))
            "<".map(.case(Instruction.prevCell))
            ",".map(.case(Instruction.input))
            ".".map(.case(Instruction.output))
            Parse {
               "["
               Many { Self() } terminator: { "]" }
            }.map(.case(Instruction.loop))
         }
      }
   }
   
   private struct ProgramParser: ParserPrinter {
      var body: some ParserPrinter<Substring, Program> {
         Many { InstructionParser() }
      }
   }
   
   /// Parses a `String` into a `Program`.
   ///
   /// - Parameter string: The original source code for a
   ///   Brainflip program.
   ///
   /// - Returns: The parsed program.
   ///
   /// - Throws: `some Error` if `string` is not a valid
   ///   program (that is, if it contains unmatched brackets).
   internal static func parse(program string: String) throws -> Program {
      try ProgramParser().parse(string.filter(
         "+-><[],.".contains // filter out nonexistent instructions
      ))
   }
   
   /// Creates a `String` representation of a ``Program``.
   ///
   /// - Parameter program: A `Program` instance.
   ///
   /// - Returns: A `String` representation of `program`.
   internal static func print(program: Program) -> String {
      String(try! ProgramParser().print(program)) // swiftlint:disable:this force_try
   }
}
