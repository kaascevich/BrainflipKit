// InputOptions.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import ArgumentParser

extension BrainflipCommand {
  struct InputOptions: ParsableArguments {
    @Option(
      name: .shortAndLong,
      help: .init(
        "The input to pass to the program.",
        discussion: """
        If this option is not specified, the input will be read from standard \
        input as the program requests it.
        """
      )
    ) var input: String?
    
    @Flag(
      inversion: .prefixedNo,
      help: .init(
        "Whether to echo input characters as they are being typed.",
        discussion: """
        This flag has no effect if the '-i/--input' option is specified.
        """
      )
    ) var inputEchoing: Bool = true
    
    @Flag(
      name: .customLong("bell"),
      inversion: .prefixedEnableDisable,
      help: .init(
        "Whether to print a bell character when the program requests input.",
        discussion: """
        This flag has no effect if the '-i/--input' option is specified.
        """
      )
    ) var bellOnInputRequest: Bool = true
  }
}
