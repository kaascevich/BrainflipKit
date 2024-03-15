// BrainflipCLI.swift
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

@main struct BrainflipCLI: AsyncParsableCommand {
   // MARK: - Command Configuration
   
   nonisolated(unsafe) static let configuration = CommandConfiguration(
      commandName: "brainflip",
      abstract: "Run Brainflip programs with a configurable interpreter.",
      discussion: """
      Brainflip is a Swift interpreter for the Brainf**k programming language
      -- an incredibly simple language that only has 8 instructions. This
      interpreter features full Unicode support (assuming the cell size is set
      to a value high enough to fit Unicode characters).
      """
   )
   
   // MARK: - Arguments
   
   @Argument(
      help: "A Brainflip program to execute.",
      transform: { string -> Program in
         do {
            return try Program(string)
         } catch {
            throw ValidationError("\n\(error)\n")
         }
      }
   ) var program: Program
   
   // MARK: - Options
   
   @Option(
      name: .shortAndLong,
      help: .init(
         "The input to pass to the program.",
         discussion: "Characters whose Unicode values exceed the maximum value of a cell will be removed."
      )
   ) var input: String = ""
   
   // MARK: - Flags
   
   @Flag(
      name: .shortAndLong,
      help: "Print the final state of the interpreter once execution is finished."
   ) var verbose: Bool = false
   
   // MARK: - Option Groups
   
   @OptionGroup(title: "Interpreter Options")
   var interpreterOptions: InterpreterOptions
   
   // MARK: - Validation
   
   func validate() throws {
      guard interpreterOptions.cellSize < Interpreter.Options.maxCellSize else {
         throw ValidationError("Invalid cell size -- must be less than \(Interpreter.Options.maxCellSize)")
      }
   }
}
