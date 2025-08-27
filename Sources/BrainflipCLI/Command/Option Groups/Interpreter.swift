// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser

extension Brainflip {
  /// Options related to the interpreter.
  struct InterpreterOptionGroup: ParsableArguments {
    // MARK: - Types

    /// The action to take on the current cell when an input instruction is
    /// executed, but there are no characters remaining in the input.
    enum EndOfInputBehavior: String, CaseIterable, ExpressibleByArgument {
      /// Sets the current cell to 0.
      case zero

      /// Sets the current cell to its maximum value.
      case max

      /// Throws an error.
      case error

      var defaultValueDescription: String {
        switch self {
        case .zero: "Sets the current cell to 0."
        case .max: "Sets the current cell to its maximum value."
        case .error: "Throws an error."
        }
      }
    }

    // MARK: - Options and Flags

    @Flag(
      name: [.customLong("wrap"), .long],
      inversion: .prefixedNo,
      help: """
        Whether to allow cell values to wrap around when they overflow or \
        underflow.
        """
    ) var wraparound = true

    @Option(
      name: [.short, .customLong("end-of-input")],
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
      ),
    ) var endOfInputBehavior: EndOfInputBehavior?
  }
}
