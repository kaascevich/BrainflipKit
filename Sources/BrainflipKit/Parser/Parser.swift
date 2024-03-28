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
   private struct ProgramParser: ParserPrinter {
      // MARK: - Utilities
      
      struct Count<
         RepeatedItem,
         Input: RangeReplaceableCollection<RepeatedItem>,
         Output: BinaryInteger
      >: Conversion {
         let repeatedItem: RepeatedItem
         @inlinable init(repeating item: RepeatedItem) {
            self.repeatedItem = item
         }
         
         @inlinable func apply(_ items: Input) throws -> Output {
            .init(items.count)
         }
         
         @inlinable func unapply(_ count: Output) throws -> Input {
            .init(repeating: repeatedItem, count: Int(count))
         }
      }
      
      struct CountRepeated<CountType: BinaryInteger>: ParserPrinter {
         let repeatedCharacter: Character
         @inlinable init(_ character: Character) {
            self.repeatedCharacter = character
         }
         
         var body: some ParserPrinter<Substring, CountType> {
            Prefix(1...) { $0 == repeatedCharacter }
               .map(Count<_, _, CountType>(repeating: repeatedCharacter))
         }
      }
      
      // MARK: - Instructions
      
      struct ExtrasParser: ParserPrinter {
         var body: some ParserPrinter<Substring, Instruction> {
            First()
               .map(.representing(ExtraInstruction.self))
               .map(.case(Instruction.extra))
         }
      }
      
      struct SetToParser: ParserPrinter {
         var body: some ParserPrinter<Substring, Instruction> {
            "[-]".utf8
            CharacterSet(charactersIn: "+")
               .map(Count(repeating: "+"))
               .map(.case(Instruction.setTo))
         }
      }
      
      struct LoopParser: ParserPrinter {
         var body: some ParserPrinter<Substring, Instruction> {
            Parse(.case(Instruction.loop)) {
               "["; ProgramParser(); "]"
            }
         }
      }
      
      struct CommentParser: ParserPrinter {
         static let validInstructions = ["+", "-", ">", "<", "[", "]", ",", "."] + ExtraInstruction.allCases.map(\.rawValue)
         
         var body: some ParserPrinter<Substring, Instruction> {
            Prefix(1...) { !Self.validInstructions.contains($0) }
               .map(.string)
               .map(.case(Instruction.comment))
         }
      }
      
      // MARK: - Main Parser
      
      var body: some ParserPrinter<Substring, Program> {
         Many {
            OneOf {
               // condense repeated instructions into a single instruction
               CountRepeated("+").map(.case(Instruction.increment))
               CountRepeated("-").map(.case(Instruction.decrement))
               CountRepeated(">").map(.case(Instruction.moveRight))
               CountRepeated("<").map(.case(Instruction.moveLeft))
               
               ",".map(.case(Instruction.input))
               ".".map(.case(Instruction.output))
               
               ExtrasParser()
               SetToParser()
               LoopParser()
               CommentParser()
            }
         }
      }
   }
}

extension BrainflipParser {
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
