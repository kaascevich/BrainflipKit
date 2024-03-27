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
private import CasePaths

@usableFromInline internal enum BrainflipParser {
   private struct ProgramParser: ParserPrinter {
      static let validInstructions = ["+", "-", ">", "<", "[", "]", ",", "."] + ExtraInstruction.allCases.map(\.rawValue)
      
      struct RepeatedInstruction<CountType: BinaryInteger>: ParserPrinter {
         let repeatedCharacter: Character
         let instruction: (CountType) -> Instruction
         init(
            _ character: Character,
            _ instruction: @escaping (CountType) -> Instruction
         ) {
            self.repeatedCharacter = character
            self.instruction = instruction
         }
         
         var body: some ParserPrinter<Substring, Instruction> {
            Prefix(1...) { $0 == repeatedCharacter }
               .map(.convert(
                  apply: { .init($0.count) },
                  unapply: { .init(repeating: repeatedCharacter, count: .init($0)) }
               )).map(.case(instruction))
         }
      }
      
      var body: some ParserPrinter<Substring, Program> {
         Many {
            OneOf {
               // MARK: Basic Instructions
               
               // condense repeated instructions into a single instruction
               RepeatedInstruction("+", Instruction.increment)
               RepeatedInstruction("-", Instruction.decrement)
               RepeatedInstruction(">", Instruction.moveRight)
               RepeatedInstruction("<", Instruction.moveLeft)
               
               ",".map(.case(Instruction.input))
               ".".map(.case(Instruction.output))
               
               // MARK: Set-to Loop
               
               "[-]".map(.case(Instruction.setTo(0)))
               
               // MARK: Loops
               
               Parse(.case(Instruction.loop)) {
                  "["; Self(); "]"
               }
               
               // MARK: Extras
               
               First()
                  .map(.representing(ExtraInstruction.self))
                  .map(.case(Instruction.extra))
               
               // MARK: Comments
               
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
