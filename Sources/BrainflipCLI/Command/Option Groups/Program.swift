// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser
import BrainflipKit
import Foundation

extension Brainflip {
  /// Options related to the program.
  struct ProgramOptionGroup: ParsableArguments {
    // MARK: - Arguments

    @Argument(
      help: .init(
        "The path to a Brainflip program to execute.",
        discussion: """
          This argument is mutually exclusive with the '-p/--program' option. \
          Exactly one should be specified.
          """,
        valueName: "file-path"
      ),
      completion: .file(extensions: ["b", "bf", "brainflip", "brainfuck"])
    ) var path: String?

    // MARK: - Options and Flags

    @Option(
      name: .shortAndLong,
      help: .init(
        "A Brainflip program to execute.",
        discussion: """
          This argument is mutually exclusive with the 'file-path' argument. \
          Exactly one should be specified.
          """
      )
    ) var program: String?
    
    // MARK: - Implementation

    /// The source code for a Brainflip program, obtained from command-line
    /// arguments or standard input.
    ///
    /// - Throws:
    ///   - ``ValidationError`` if both the `<file-path>` and `-p/--program`
    ///     options are provided (or if neither is).
    ///   - ``Error`` if a file path can't be opened for whatever reason.
    private var programSource: String {
      get throws {
        switch (path, program) {
        case let (path?, nil):
          // if they provided a program path, read from that file
          try String(contentsOfFile: path, encoding: .utf8)

        case let (nil, program?):
          // if they provided a program, just use that
          program

        default:
          throw ValidationError(
            "Exactly one of 'file-path' or '-p/--program' must be specified."
          )
        }
      }
    }

    /// Obtains the source code for a Brainflip program from command-line
    /// arguments or standard input, then returns the result of parsing that
    /// program.
    ///
    /// - Returns: The result of parsing the Brainflip program provided by the
    ///   user.
    func parseProgram() throws -> Program {
      try Program(try programSource)
    }
  }
}
