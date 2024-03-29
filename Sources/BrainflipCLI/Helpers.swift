// Helpers.swift
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

import ArgumentParser
import BrainflipKit

extension BrainflipCLI {
   /// Reads text from standard input until EOF is reached.
   ///
   /// - Returns: Text read from standard input.
   ///
   /// - Throws: `ValidationError` if standard input only
   ///   contains whitespace.
   func readFromStandardInput() async throws -> String {
      var input = ""
      while let nextLine = readLine() {
         input += nextLine
      }
      
      if input.allSatisfy(\.isWhitespace) {
         // if they didn't type anything meaningful, just
         // print usage info and exit
         throw ValidationError("")
      }
      
      return input
   }
   
   /// Formats the given program, indenting loops.
   ///
   /// - Parameters:
   ///   - program: The program to indent.
   ///   - indentLevel: The level of indentation to apply.
   ///
   /// - Returns: A formatted program.
   func formatProgram(_ program: Program, indentLevel: Int = 0) -> String {
      var lines: [String] = []
      
      let indent = String(repeating: "  ", count: indentLevel)
      
      for instruction in program {
         let linesToAppend = switch instruction {
         case .loop(let instructions): [
            indent + "loop(",
            // don't apply any indent here, because that'll be redundant
            formatProgram(instructions, indentLevel: indentLevel + 1),
            indent + ")"
         ]
         
         // output the instruction's details
         default: [indent + String(describing: instruction)]
         }
         
         lines += linesToAppend
      }
      
      return lines.joined(separator: "\n")
   }
   
   /// Obtains the source code for a Brainflip program
   /// from command-line arguments or standard input.
   ///
   /// - Returns: The source code for the Brainflip
   ///   program provided by the user.
   func getProgramSource() async throws -> String {
      switch (programPath, program) {
      case (nil, nil):
         try await readFromStandardInput()
         
      case (let programPath?, nil):
         try String(contentsOfFile: programPath)
         
      case (nil, let program?):
         program
         
      case (_?, _?):
         throw ValidationError(
            "Only one of 'file-path' or '-p/--program' must be provided."
         )
      }
   }
}
