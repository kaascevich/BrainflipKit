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

import Parsing

internal enum BrainflipParser {
   struct InstructionParser: Parser {
      let optimizations: Bool
      init(optimizations: Bool = true) {
         self.optimizations = optimizations
      }
      
      // MARK: - Instructions
      
      struct ExtrasParser: Parser {
         var body: some Parser<Substring, Instruction> {
            First()
               .map(.representing(ExtraInstruction.self))
               .map(Instruction.extra)
         }
      }
      
      struct LoopParser: Parser {
         let optimizations: Bool
         init(optimizations: Bool = true) {
            self.optimizations = optimizations
         }
         
         var body: some Parser<Substring, Instruction> {
            Parse(Instruction.loop) {
               "["
               ProgramParser(optimizations: optimizations)
               "]"
            }
         }
      }
      
      // MARK: - Main Parser
      
      var body: some Parser<Substring, Instruction> {
         OneOf {
            "+".map { Instruction.add(+1) }
            "-".map { Instruction.add(-1) }
            
            ">".map { Instruction.move(+1) }
            "<".map { Instruction.move(-1) }
            
            ",".map { Instruction.input }
            ".".map { Instruction.output }
            
            ExtrasParser()
            LoopParser(optimizations: optimizations)
         }
      }
   }
   
   struct ProgramParser: Parser {
      let optimizations: Bool
      init(optimizations: Bool = true) {
         self.optimizations = optimizations
      }
      
      var body: some Parser<Substring, Program> {
         if optimizations {
            Many { InstructionParser(optimizations: optimizations) }
               .map(BrainflipOptimizer.optimizingWithoutNesting)
         } else {
            Many { InstructionParser(optimizations: optimizations) }
         }
      }
   }
}

extension BrainflipParser {
   static let validInstructions = ["+", "-", ">", "<", "[", "]", ",", "."]
      + ExtraInstruction.allCases.map(\.rawValue)
   
   /// Parses a `String` into a ``Program``.
   ///
   /// - Parameters:
   ///   - string: The original source code for a
   ///     Brainflip program.
   ///   - optimizations: Whether to optimize the
   ///     program.
   ///
   /// - Returns: The parsed program.
   ///
   /// - Throws: An `Error` if `string` cannot be parsed
   ///   into a valid program (that is, if it contains
   ///   unmatched brackets).
   @usableFromInline static func parse(
      program string: String,
      optimizations: Bool = true
   ) throws -> Program {
      try ProgramParser(optimizations: optimizations)
         .parse(string.filter(validInstructions.contains))
   }
}
