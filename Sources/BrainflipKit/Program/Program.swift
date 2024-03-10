// Program.swift
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

/// A list of instructions to be executed by an ``Interpreter``.
public typealias Program = [Instruction]

// swiftlint:disable cyclomatic_complexity
public extension Program {
   /// Parses the given string into a `Program`.
   ///
   /// The following mappings are used to convert a `Character`
   /// into an ``Instruction``:
   ///
   /// | Character |        Instruction        |
   /// |-----------|---------------------------|
   /// |    `+`    | ``Instruction/increment`` |
   /// |    `-`    | ``Instruction/decrement`` |
   /// |    `>`    | ``Instruction/nextCell``  |
   /// |    `<`    | ``Instruction/prevCell``  |
   /// |  `[` `]`  | ``Instruction/loop(_:)``  |
   /// |    `.`    | ``Instruction/output``    |
   /// |    `,`    | ``Instruction/input``     |
   ///
   /// All other characters are treated as comments and ignored.
   ///
   /// - Parameter string: A string to parse into a `Program`.
   ///
   /// - Returns: `nil` if `string` contains unmatched brackets.
   init?(_ string: String) {
      // quickly check the obvious...
      guard string.filter({ $0 == "[" }).count == string.filter({ $0 == "]" }).count else {
         return nil // this'll catch the majority of bracket matching errors
      }
      
      guard let program = Self.parse(program: string) else {
         return nil
      }
      self = program
   }
   
   private static func parse(program string: String) -> Program? {
      var index = string.startIndex
      var program: Program = []
      
      while string.indices.contains(index) {
         let character = string[index]
         switch character {
         case "+": program.append(.increment)
         case "-": program.append(.decrement)
         case ">": program.append(.nextCell)
         case "<": program.append(.prevCell)
         case ",": program.append(.input)
         case ".": program.append(.output)
            
         case "[":
            // we need to find where this loop ends in order to create
            // the instruction
            
            guard string.indices.contains(index) else {
               return nil
            }
            
            let startIndex = string.index(after: index)
            
            let endIndex: String.Index? = {
               var index = startIndex
               var nestingLevel = 1 // we're starting off in a loop
               
               // we use a very simple stack-like process, except we
               // only store the *size* of the stack in `nestingLevel`
               while nestingLevel > 0 {
                  guard string.indices.contains(index) else {
                     return nil
                  }
                  
                  index = string.index(after: index)
                  
                  if string[index] == "[" {
                     // there's a nested loop inside of this one, so we
                     // need to accomodate it
                     nestingLevel += 1
                  }
                  if string[index] == "]" {
                     // we're exiting a loop
                     nestingLevel -= 1
                  }
               }
               
               return index
            }()
            
            guard let endIndex else {
               return nil
            }
            
            let loopedCharacters = String(string[startIndex...endIndex])
            guard let loopedInstructions = parse(program: loopedCharacters) else {
               return nil
            }
            program.append(.loop(loopedInstructions))
            index = endIndex
            
         case "]": break // above case should handle it
            
         default: break // ignore all other characters
         }
         
         index = string.index(after: index)
      }
      
      return program
   }
}
// swiftlint:enable cyclomatic_complexity

public extension Program {
   var description: String {
      self.map {
         switch $0 {
         case .increment: "+"
         case .decrement: "-"
         case .nextCell: ">"
         case .prevCell: "<"
         case .output: "."
         case .input: ","
         case .loop(let instructions): "[\(Program(instructions).description)]"
         }
      }.joined()
   }
}
