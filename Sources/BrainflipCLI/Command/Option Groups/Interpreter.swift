// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser
import BrainflipKit

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

            /// Sets the current cell to its minimum value.
            case min

            /// Sets the current cell to -1.
            case negativeOne = "-1"

            var defaultValueDescription: String {
                switch self {
                    case .zero: "Sets the current cell to 0."
                    case .max: "Sets the current cell to its maximum value."
                    case .min: "Sets the current cell to its minimum value."
                    case .negativeOne: "Sets the current cell to -1."
                }
            }
        }

        // MARK: - Options and Flags

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

        // MARK: Helpers

        /// Creates an ``InterpreterOptions`` struct from the command-line options.
        ///
        /// - Returns: An ``InterpreterOptions`` struct.
        func makeInterpreterOptions() -> InterpreterOptions {
            let endOfInputBehavior: InterpreterOptions.EndOfInputBehavior =
                switch endOfInputBehavior {
                    case .zero: .setTo(0)
                    case .max: .setTo(.max)
                    case .min: .setTo(.min)
                    case .negativeOne: .setTo(-1)
                    case nil: .doNothing
                }

            return InterpreterOptions(endOfInputBehavior: endOfInputBehavior)
        }
    }
}
