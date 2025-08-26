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
  /// Options related to the interpreter.
  struct InterpreterOptionGroup: ParsableArguments {
    /// The action to take on the current cell when an input instruction is
    /// executed, but there are no characters remaining in the input.
    enum EndOfInputBehavior: String, CaseIterable, ExpressibleByArgument {
      case zero, max
      case error
    }

    @Flag(
      name: [.customLong("wrap"), .long],
      inversion: .prefixedNo,
      help: """
        Whether to allow cell values to wrap around when they overflow or \
        underflow.
        """
    ) var wraparound: Bool = true

    @Option(
      name: [.customLong("eoi"), .customLong("end-of-input")],
      help: .init(
        """
        The action to take on the current cell when an input instruction is \
        executed, but there are no characters remaining in the input iterator.
        """,
        discussion: """
          No action is taken if this option is not specified. To signal \
          end-of-input, type ^D (control-D).
          """,
        valueName: "behavior"
      )
    ) var endOfInputBehavior: EndOfInputBehavior?
  }
}
