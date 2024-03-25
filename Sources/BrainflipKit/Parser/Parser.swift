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

private import Parsing

@usableFromInline internal enum BrainflipParser {
   private struct ProgramParser: ParserPrinter {
      static let validInstructions = ["+", "-", ">", "<", "[", "]", ",", "."]
      + ExtraInstruction.allCases.map(\.rawValue)
      
      var body: some ParserPrinter<Substring, Program> {
         Many {
            OneOf {
               "+".map(.case(Instruction.increment))
               "-".map(.case(Instruction.decrement))
               ">".map(.case(Instruction.nextCell))
               "<".map(.case(Instruction.prevCell))
               ",".map(.case(Instruction.input))
               ".".map(.case(Instruction.output))
               
               Parse { "["; Self(); "]" }
                  .map(.case(Instruction.loop))
               
               First()
                  .map(.representing(ExtraInstruction.self))
                  .map(.case(Instruction.extra))
               
               Prefix(1...) { !Self.validInstructions.contains($0) }
                  .map(.string)
                  .map(.case(Instruction.comment))
            }
         }
      }
   }
   
   /// Parses a `String` into a ``Program``.
   ///
   /// - Parameter string: The original source code for a
   ///   Brainflip program.
   ///
   /// - Returns: The parsed program.
   ///
   /// - Throws: An `Error` if `string` cannot be parsed
   ///   into a valid program (that is, if it contains
   ///   unmatched brackets).
   @usableFromInline static func parse(program string: String) throws -> Program {
      try ProgramParser().parse(string)
   }
   
   /// Creates a `String` representation of a ``Program``.
   ///
   /// - Parameter program: A `Program` instance.
   ///
   /// - Returns: A `String` representation of `program`.
   @usableFromInline static func print(program: Program) -> String {
      String(try! ProgramParser().print(program)) // swiftlint:disable:this force_try
   }
}
