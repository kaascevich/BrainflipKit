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
   struct InstructionParser: Parser {
      let optimizations: Bool
            
      var body: some Parser<Substring.UTF8View, Instruction> {
         OneOf {
            // MARK: Simple
            
            "+".utf8.map { Instruction.add(+1) }
            "-".utf8.map { Instruction.add(-1) }
            
            ">".utf8.map { Instruction.move(+1) }
            "<".utf8.map { Instruction.move(-1) }
            
            ",".utf8.map { Instruction.input }
            ".".utf8.map { Instruction.output }
            
            // MARK: Extras
            
            From(.substring) {
               First().map(.representing(ExtraInstruction.self))
            }
            .map(Instruction.extra)
            
            // MARK: Loops
            
            Parse(Instruction.loop) {
               "[".utf8
               ProgramParser(optimizations: optimizations)
               "]".utf8
            }
         }
      }
   }
   
   struct ProgramParser: Parser {
      let optimizations: Bool
      var body: some Parser<Substring.UTF8View, Program> {
         let programParser = Many {
            InstructionParser(optimizations: optimizations)
         }
         
         if optimizations {
            programParser.map(BrainflipOptimizer.optimizingWithoutNesting)
         } else {
            programParser
         }
      }
   }
}

extension BrainflipParser {
   /// Parses a `String` into a ``Program``.
   ///
   /// - Parameters:
   ///   - source: The original source code for a
   ///     Brainflip program.
   ///   - optimizations: Whether to optimize the
   ///     program.
   ///
   /// - Returns: The parsed program.
   ///
   /// - Throws: An `Error` if `source` cannot be parsed
   ///   into a valid program (that is, if it contains
   ///   unmatched brackets).
   static func parse(
      program source: String,
      optimizations: Bool = true
   ) async throws -> Program {
      try ProgramParser(optimizations: optimizations)
         .parse(source.filter(Instruction.validInstructions.contains))
   }
}
