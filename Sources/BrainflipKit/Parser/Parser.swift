// Parser.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

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
