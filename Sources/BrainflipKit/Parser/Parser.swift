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
      var body: some ParserPrinter<Substring.UTF8View, Instruction> {
         OneOf {
            "+".utf8.map(.case(Instruction.increment))
            "-".utf8.map(.case(Instruction.decrement))
            ">".utf8.map(.case(Instruction.nextCell))
            "<".utf8.map(.case(Instruction.prevCell))
            ",".utf8.map(.case(Instruction.input))
            ".".utf8.map(.case(Instruction.output))
            Parse {
               "[".utf8
               Many { Self() } terminator: { "]".utf8 }
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
   static func parse(program string: String) throws -> Program {
      try ProgramParser().parse(string.filter("+-><[],.".contains))
   }
   
   /// Creates a `String` representation of a ``Program``.
   ///
   /// - Parameter program: A `Program` instance.
   ///
   /// - Returns: A `String` representation of `program`.
   static func print(program: Program) -> String {
      String(try! ProgramParser().print(program)) // swiftlint:disable:this force_try
   }
}
