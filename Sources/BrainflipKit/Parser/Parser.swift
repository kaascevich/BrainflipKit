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

import Foundation

private import Parsing

internal enum BrainflipParser {
   private struct ProgramParser: Parser {
      // MARK: - Utilities
      
      struct CountRepeated<CountType: BinaryInteger>: Parser {
         let repeatedCharacter: Character
         @inlinable init(_ character: Character) {
            self.repeatedCharacter = character
         }
         
         var body: some Parser<Substring, CountType> {
            Prefix(1...) { $0 == repeatedCharacter }
               .map(\.count)
               .map(CountType.init(_:))
         }
      }
      
      // MARK: - Instructions
      
      struct ExtrasParser: Parser {
         var body: some Parser<Substring, Instruction> {
            First()
               .map(.representing(ExtraInstruction.self))
               .map(Instruction.extra)
         }
      }
      
      struct SetToZeroParser: Parser {
         var body: some Parser<Substring, Instruction> {
            "[-]".map(.case(Instruction.setTo(0)))
         }
      }
      
      struct LoopParser: Parser {
         var body: some Parser<Substring, Instruction> {
            Parse {
               "["; ProgramParser(); "]"
            }.map(Instruction.loop)
         }
      }
      
      // MARK: - Main Parser
      
      var body: some Parser<Substring, Program> {
         Many {
            OneOf {
               // condense repeated instructions into a single instruction
               CountRepeated("+").map(Instruction.increment)
               CountRepeated("-").map(Instruction.decrement)
               
               CountRepeated(">")
                  .map(Instruction.move)
               CountRepeated("<")
                  .map(-).map(Instruction.move)
               
               ",".map(.case(Instruction.input))
               ".".map(.case(Instruction.output))
               
               ExtrasParser()
               SetToZeroParser()
               LoopParser()
            }
         }
      }
   }
}

extension BrainflipParser {
   static let validInstructions = ["+", "-", ">", "<", "[", "]", ",", "."] + ExtraInstruction.allCases.map(\.rawValue)
   
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
      try ProgramParser().parse(string.filter(validInstructions.contains))
   }
}
