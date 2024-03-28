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
import struct Foundation.URL

import BrainflipKit

@main struct BrainflipCLI: AsyncParsableCommand {
   // MARK: - Command Configuration
   
   static let configuration = CommandConfiguration(
      commandName: "brainflip",
      abstract: "Run Brainflip programs with a configurable interpreter.",
      discussion: """
      Brainflip is an optimizing Swift interpreter for the Brainf**k programming \
      language -- an incredibly simple language that only has 8 instructions. This \
      interpreter features full Unicode support, as well as languange extensions in \
      the form of extra instructions (which can be enabled or disabled at will).
      """
   )
   
   static let validExtensions = ["bf", "brainflip", "brainfuck"]
   static let formattedValidExtensions = validExtensions
      .map { "." + $0 }
      .formatted(
         .list(type: .or)
         .locale(.init(identifier: "en-us"))
      )
   
   // MARK: - Arguments
   
   @Argument(
      help: .init(
         "The path to a Brainflip program to execute.",
         discussion: """
         The file extension must be one of \(formattedValidExtensions). If neither \
         this argument nor the '-p/--program' option is provided, the program will \
         be read from standard input.
         
         This argument is mutually exclusive with the '-p/--program' option. Only \
         one should be specified.
         """,
         valueName: "file-path"
      ),
      completion: .file(extensions: validExtensions),
      transform: { filePath in
         guard let url = URL(string: filePath) else {
            throw ValidationError("That file doesn't exist.")
         }
         
         guard validExtensions.contains(url.pathExtension) else {
            throw ValidationError("Invalid file type -- must be one of \(formattedValidExtensions).")
         }
         
         return filePath
      }
   ) var programPath: String?
   
   // MARK: - Options
   
   @Option(
      name: [.short, .customLong("program")],
      help: .init(
         "A Brainflip program to execute.",
         discussion: """
         If neither this option nor the 'file-path' argument is provided, the \
         program will be read from standard input.
         
         This argument is mutually exclusive with the 'file-path' argument. Only \
         one should be specified.
         """
      )
   ) var program: String?
   
   @Option(name: .shortAndLong, help: "The input to pass to the program.")
   var input: String = ""
   
   // MARK: - Flags
   
   @Flag(
      name: .long,
      help: "Prints the result of parsing the program and exits."
   ) var printParsed: Bool = false
   
   // MARK: - Option Groups
   
   @OptionGroup(title: "Interpreter Options")
   var interpreterOptions: InterpreterOptions
   
   // MARK: - State
   
   internal var parsedProgram: Program = []
   
   // MARK: - Validation
   
   mutating func validate() async throws {
      parsedProgram = switch (programPath, program) {
      case (nil, nil):
         try Program(await readFromStandardInput())
         
      case (let programPath?, nil):
         try Program(String(contentsOfFile: programPath))
         
      case (nil, let program?):
         try Program(program)
         
      case (_?, _?):
         throw ValidationError("Only one of 'file-path' or '-p/--program' must be provided.")
      }
   }
}
