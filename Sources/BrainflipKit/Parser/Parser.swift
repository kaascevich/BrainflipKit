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

internal import Parsing
internal typealias ParserProtocol = Parsing.Parser

internal extension Program {
   struct Parser: ParserProtocol {
      /// Whether to optimize the parsed program.
      let optimizations: Bool
      
      private struct InstructionParser: ParserProtocol {
         let optimizations: Bool
         
         var body: some ParserProtocol<Substring.UTF8View, Instruction> {
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
                  Program.Parser(optimizations: optimizations)
                  "]".utf8
               }
            }
         }
      }
      
      var body: some ParserProtocol<Substring.UTF8View, Program> {
         let programParser = Many {
            InstructionParser(optimizations: optimizations)
         }
         
         if optimizations {
            programParser.map(Optimizer.optimizingWithoutNesting)
         } else {
            programParser
         }
      }
   }
}
