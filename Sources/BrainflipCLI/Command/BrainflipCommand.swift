// BrainflipCommand.swift
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

@main struct BrainflipCommand: AsyncParsableCommand {
   // MARK: - Command Configuration
   
   static let configuration = CommandConfiguration(
      commandName: "brainflip",
      abstract: "Run brainf**k programs with a configurable interpreter.",
      discussion: """
      Brainflip is an optimizing Swift interpreter for the brainf**k \
      programming language -- an incredibly simple language that only has 8 \
      instructions. This interpreter features full Unicode support, as well as \
      languange extensions in the form of extra instructions (which can be \
      enabled or disabled at will).
      
      Here's a list of all the differences between Brainflip and a standard, \
      run-of-the-mill brainf**k interpreter:
       - Full Unicode support
       - 32-bit cells instead of 8-bit cells ('cuz Unicode)
       - Infinite tape in both directions
       - Customizable end-of-input behavior
       - Cell wrapping can be disabled
       - Optional extra instructions
       - Relatively basic optimizations, including:
         - Condensing repeated instructions
         - Merging `+`/`-` and `<`/`>` instructions
         - Removing instructions that cancel each other out
         - Replacing `[-]` with a dedicated instruction
         - Replacing copy/multiplication loops with a dedicated instruction
         - Replacing scan loops (such as `[>>]`) with a dedicated instruction
      """
   )
   
   static let validExtensions = ["b", "bf", "brainflip", "brainfuck"]
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
         The file extension must be one of \(formattedValidExtensions). If \
         neither this argument nor the '-p/--program' option is provided, the \
         program will be read from standard input.
         
         This argument is mutually exclusive with the '-p/--program' option. \
         Only one should be specified.
         """,
         valueName: "file-path"
      ),
      completion: .file(extensions: validExtensions),
      transform: { filePath in
         guard let url = URL(string: filePath) else {
            throw ValidationError("That file doesn't exist.")
         }
         
         guard validExtensions.contains(url.pathExtension) else {
            throw ValidationError(
               "Invalid file type -- must be one of \(formattedValidExtensions)."
            )
         }
         
         return filePath
      }
   ) var programPath: String?
      
   @Option(
      name: [.short, .customLong("program")],
      help: .init(
         "A Brainflip program to execute.",
         discussion: """
         If neither this option nor the 'file-path' argument is provided, the \
         program will be read from standard input.
         
         This argument is mutually exclusive with the 'file-path' argument. \
         Only one should be specified.
         """
      )
   ) var program: String?
   
   @Flag(
      inversion: .prefixedEnableDisable,
      help: "Whether to optimize the program before interpreting it."
   ) var optimizations: Bool = true
      
   @Flag(
      help: "Prints the result of parsing the program and exits."
   ) var printParsed: Bool = false
   
   @Flag(
      help: .init(
         """
         Prints the result of filtering non-instruction characters from the \
         program and exits.
         """,
         discussion: "This flag overrides the '--print-parsed' flag."
      )
   ) var printFiltered: Bool = false
   
   // MARK: - Option Groups
   
   @OptionGroup(title: "Interpreter Options")
   var interpreterOptions: InterpreterOptions
   
   @OptionGroup(title: "Input Options")
   var inputOptions: InputOptions
}
