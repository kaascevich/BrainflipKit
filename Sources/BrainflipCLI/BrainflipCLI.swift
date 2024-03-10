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
   
   static let configuration = CommandConfiguration(
      commandName: "brainflip",
      abstract: "Run Brainflip programs with a configurable interpreter."
   )
   
   // MARK: - Arguments
   
   @Argument(
      help: "A Brainflip program to execute.",
      transform: { string in
         guard let program = Program(string) else {
            throw ValidationError(Interpreter<UTF8>.Error.invalidProgram.description)
         }
         return program
      }
   ) var program: Program
   
   // MARK: - Options
   
   @Option(name: .shortAndLong, help: "The input to pass to the program.")
   var input: String = ""
   
   @OptionGroup(title: "Interpreter Options")
   var interpreterOptions: InterpreterOptions
}
