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

public enum Parser {
   /// Parses a `String` into a `Program`.
   ///
   /// - Parameter string: The original source code for a
   ///   Brainflip program.
   ///
   /// - Returns: The parsed program.
   ///
   /// - Throws: ``InvalidProgramError`` if `string` is not
   ///   a valid program (that is, if it contains unmatched
   ///   brackets).
   internal static func parse(program string: String) throws -> Program {
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
            let (instructions, newIndex) = try parseLoop(in: string, at: index)
            index = newIndex
            program.append(.loop(instructions))
            
         case "]":
            // if we got here, then there's an extra closing bracket
            // that doesn't have a matching opening bracket
            throw InvalidProgramError(string)
            
         default: break // ignore all other characters
         }
         
         index = string.index(after: index)
      }
      
      return program
   }
   
   /// Parse a loop.
   ///
   /// - Parameters:
   ///   - string: The program string, trimmed of comment
   ///     characters.
   ///   - index: The index of the beginning of this loop.
   ///
   /// - Returns: The instructions contained within the loop,
   ///   as well as the index where the loop ends.
   ///
   /// - Throws: ``InvalidProgramError`` if `string` is not
   ///   a valid program (that is, if it contains unmatched
   ///   brackets).
   private static func parseLoop(
      in string: String,
      at index: String.Index
   ) throws -> ([Instruction], endIndex: String.Index) {
      guard string.indices.contains(index) else { throw InvalidProgramError(string) }
      
      /// The index of the first character in this loop.
      let startIndex = string.index(after: index)
      
      /// The indices to search in for this loop's end index.
      let searchIndices = startIndex..<string.endIndex
      
      /// The amount of nested loops we're currently in.
      var nestingLevel = 0
      
      // we use a very simple stack-like process to find the
      // end index, except we only store the *size* of the
      // stack in `nestingLevel`
      let endIndex: String.Index = try {
         for index in string.indices[searchIndices] {
            // check if there's a nested loop inside of this one,
            // so we can accomodate for it
            if string[index] == "[" { nestingLevel += 1 }
            
            // check if we're exiting a nested loop
            if string[index] == "]" { nestingLevel -= 1 }
            
            // check if we've exited the loop we're parsing - if
            // so, we've found the index we need
            if nestingLevel < 0 {
               return index
            }
         }
         
         // this loop doesn't have a closing bracket, so the
         // program is invalid
         throw InvalidProgramError(string)
      }()
      
      let loopedCharacters = string[startIndex..<endIndex]
      let loopedInstructions = try parse(program: String(loopedCharacters))
      return (loopedInstructions, endIndex)
   }
}
