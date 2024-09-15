// Parser.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Parsing
typealias ParserProtocol = Parsing.Parser

extension Program {
  /// A parser that parses a program.
  struct Parser: ParserProtocol {
    /// Whether to optimize the parsed program.
    let optimizations: Bool
    
    /// A parser that parses a single instruction.
    private struct InstructionParser: ParserProtocol {
      /// Whether to optimize the parsed program.
      let optimizations: Bool
      
      var body: some ParserProtocol<Substring, Instruction> {
        OneOf {
          // MARK: Simple
          
          "+".map { Instruction.add(+1) }
          "-".map { Instruction.add(-1) }
          
          ">".map { Instruction.move(+1) }
          "<".map { Instruction.move(-1) }
          
          ",".map { Instruction.input }
          ".".map { Instruction.output }
          
          // MARK: Extras
          
          First()
            .map(.representing(ExtraInstruction.self))
            .map(Instruction.extra)
          
          // MARK: Loops
          
          Parse(Instruction.loop) {
            "["
            Program.Parser(optimizations: optimizations)
            "]"
          }
        }
      }
    }
    
    var body: some ParserProtocol<Substring, Program> {
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
