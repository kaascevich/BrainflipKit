// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser
import BrainflipKit
import CustomDump

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
      customDump(parsedProgram)
    }
  }
}
