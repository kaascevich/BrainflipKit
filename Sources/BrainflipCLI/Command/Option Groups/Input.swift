// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser

extension Brainflip {
  /// Options related to input.
  struct InputOptionGroup: ParsableArguments {
    // MARK: - Options and Flags

    @Option(
      name: .shortAndLong,
      help: .init(
        "The input to pass to the program.",
        discussion: """
          If this option is not specified, the input will be read from \
          standard input as the program requests it.
          """
      )
    ) var input: String?

    @Flag(
      name: .customLong("echo"),
      inversion: .prefixedEnableDisable,
      help: .init(
        "Whether to echo input characters as they are being typed.",
        discussion: """
          This flag has no effect if the '-i/--input' option is specified.
          """
      )
    ) var inputEchoing = true

    @Flag(
      name: .customLong("bell"),
      inversion: .prefixedEnableDisable,
      help: .init(
        "Whether to print a bell character when the program requests input.",
        discussion: """
          This flag has no effect if the '-i/--input' option is specified.
          """
      )
    ) var bellOnInputRequest = true
  }
}
