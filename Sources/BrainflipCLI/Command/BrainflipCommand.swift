// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

import ArgumentParser
import Foundation

/// The main command for the Brainflip CLI.
@main struct BrainflipCommand: AsyncParsableCommand {
  // MARK: - Command Configuration

  static let configuration = CommandConfiguration(
    commandName: "brainflip",
    abstract: "Run brainf**k programs with a configurable interpreter.",
    discussion: """
      Brainflip is an optimizing Swift interpreter for the brainfuck \
      programming language -- an incredibly simple language that only has 8 \
      instructions. This interpreter features full Unicode support.

      Here's a list of all the differences between Brainflip and a standard, \
      run-of-the-mill brainf**k interpreter:
      - Full Unicode support
      - 32-bit cells instead of 8-bit cells ('cuz Unicode)
      - Infinite tape in both directions
      - Customizable end-of-input behavior
      - Cell wrapping can be disabled
      - Relatively basic optimizations, including:
        - Condensing repeated instructions
        - Merging `+`/`-` and `<`/`>` instructions
        - Removing instructions that cancel each other out
        - Replacing `[-]` with a dedicated instruction
        - Replacing copy/multiplication loops with a dedicated instruction
        - Replacing scan loops (such as `[>>]`) with a dedicated instruction
      """
  )

  /// The valid file extensions for Brainflip programs.
  static let validExtensions = ["b", "bf", "brainflip", "brainfuck"]

  /// A formatted list of valid file extensions.
  static let formattedValidExtensions =
    validExtensions
    .map { "." + $0 }
    .formatted(.list(type: .or).locale(.init(identifier: "en-us")))

  // MARK: - Arguments

  @Argument(
    help: .init(
      "The path to a Brainflip program to execute.",
      discussion: """
        The file extension must be one of \(formattedValidExtensions).

        This argument is mutually exclusive with the '-p/--program' option. \
        Exactly one should be specified.
        """,
      valueName: "file-path"
    ),
    completion: .file(extensions: validExtensions),
    transform: { filePath in
      guard
        let url = URL(string: filePath),
        FileManager.default.fileExists(atPath: url.path)
      else {
        throw ValidationError("That file doesn't exist.")
      }

      guard validExtensions.contains(url.pathExtension) else {
        throw ValidationError(
          "Invalid file type -- must be one of \(formattedValidExtensions).",
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
        This argument is mutually exclusive with the 'file-path' argument. \
        Exactly one should be specified.
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
  var interpreterOptions: InterpreterOptionGroup

  @OptionGroup(title: "Input Options")
  var inputOptions: InputOptionGroup
}
