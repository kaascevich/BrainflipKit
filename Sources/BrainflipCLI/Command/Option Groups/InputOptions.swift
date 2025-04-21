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

extension BrainflipCommand {
  /// Options related to input.
  struct InputOptions: ParsableArguments {
    @Option(
      name: .shortAndLong,
      help: .init(
        "The input to pass to the program.",
        discussion: """
        If this option is not specified, the input will be read from standard \
        input as the program requests it.
        """,
      ),
    ) var input: String?

    @Flag(
      inversion: .prefixedNo,
      help: .init(
        "Whether to echo input characters as they are being typed.",
        discussion: """
        This flag has no effect if the '-i/--input' option is specified.
        """,
      ),
    ) var inputEchoing: Bool = true

    @Flag(
      name: .customLong("bell"),
      inversion: .prefixedEnableDisable,
      help: .init(
        "Whether to print a bell character when the program requests input.",
        discussion: """
        This flag has no effect if the '-i/--input' option is specified.
        """,
      ),
    ) var bellOnInputRequest: Bool = true
  }
}
