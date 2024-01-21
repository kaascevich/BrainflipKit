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
import OSLog

@main struct BrainflipCLI: AsyncParsableCommand {
   // MARK: - Command Configuration
   
   static let configuration =  CommandConfiguration(
      commandName: "brainflip",
      abstract: "Run and debug Brainflip programs."
   )
   
   // MARK: - Arguments
   
   @Argument(
      help: "A Brainflip program to execute.",
      transform: Program.init(_:)
   ) var program: Program
   
   // MARK: - Options
   
   @Option(
      name: [.short, .long],
      help: .init(
         "The input to pass to the program.",
         discussion: "If specified, the input must exclusively contain ASCII characters."
      )
   ) var input: String = ""
   
   // MARK: - Flags
   
   @Flag(
      help: "Checks the program for errors and exits."
   ) var checkOnly: Bool = false
   
   // MARK: - Validation
   
   func validate() throws {
      let nonASCIICharacters = input.filter { !$0.isASCII }
      guard nonASCIICharacters.isEmpty else {
         let quotedCharacters = input.map { "'\($0)'" }
         throw ValidationError("non-ASCII characters found in input (namely, \(quotedCharacters.formatted())).")
      }
   }
   
   // MARK: - Implementation
   
   func run() async throws {
      let interpreter = Interpreter(program)
      
      if checkOnly {
         try await interpreter.checkProgram()
         throw CleanExit.message("No issues found.")
      }
      
      let output = try await interpreter.run(input: input)
      throw CleanExit.message(output)
   }
}
