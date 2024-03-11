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
      abstract: "Run Brainflip programs with a configurable interpreter."
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
   )
   var input: String = ""
   
   @OptionGroup(title: "Interpreter Options")
   var interpreterOptions: InterpreterOptions
   
   // MARK: - Validation
   
   func validate() throws {
      guard (1...32).contains(interpreterOptions.cellSize) else {
         throw ValidationError("Invalid cell size -- must be between 1 and 32")
      }
   }
}
