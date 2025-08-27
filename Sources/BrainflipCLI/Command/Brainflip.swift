// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser

/// The main command for the Brainflip CLI.
@main struct Brainflip: ParsableCommand {
  // MARK: - Command Configuration

  static let configuration = CommandConfiguration(
    abstract: "Run brainfuck programs with a configurable interpreter.",
    discussion: """
      Brainflip is an optimizing Swift interpreter for the brainfuck \
      programming language -- an incredibly simple language that only has 8 \
      instructions. This interpreter features 32-bit cells, full Unicode \
      support, an infinite tape in both directions, simple runtime \
      optimizations, and several configuration options.
      """,
    subcommands: [Run.self, Parse.self],
    defaultSubcommand: Run.self
  )
}
