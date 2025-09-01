// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser
import BrainflipKit

extension Brainflip {
  struct Parse: ParsableCommand {
    // MARK: - Command Configuration

    static let configuration = CommandConfiguration(
      abstract: "Parses and pretty-prints a brainfuck program."
    )

    // MARK: - Option Groups

    @OptionGroup(title: "Program Options")
    var programOptions: ProgramOptionGroup

    func run() throws {
      let parsedProgram = try programOptions.parseProgram()
      print(parsedProgram.formatted())
    }
  }
}

extension Program {
  /// Formats this program, indenting loops.
  ///
  /// - Parameters:
  ///   - indentLevel: The level of indentation to apply.
  ///
  /// - Returns: The formatted program.
  func formatted(indentLevel: Int = 0) -> String {
    let indent = String(repeating: "  ", count: indentLevel)

    return self.flatMap { instruction in
      switch instruction {
      case .loop(let instructions):
        [
          indent + "loop {",

          // don't apply any indent here, because that'll be redundant
          instructions.formatted(indentLevel: indentLevel + 1),

          indent + "}",
        ]
      default:
        [indent + String(describing: instruction)]
      }
    }.joined(separator: "\n")
  }
}
