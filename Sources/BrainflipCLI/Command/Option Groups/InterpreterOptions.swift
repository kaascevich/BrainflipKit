// InterpreterOptions.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import ArgumentParser
import enum BrainflipKit.ExtraInstruction

extension BrainflipCommand {
  /// Options related to the interpreter.
  struct InterpreterOptions: ParsableArguments {
    /// The action to take on the current cell when an input instruction
    /// is executed, but there are no characters remaining in the input.
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
        The action to take on the current cell when an input instruction \
        is executed, but there are no characters remaining in the input \
        iterator.
        """,
        discussion: "No action is taken if this option is not specified.",
        valueName: "behavior"
      )
    ) var endOfInputBehavior: EndOfInputBehavior?
    
    @Option(
      name: [.customShort("x"), .customLong("extras"), .long],
      parsing: .upToNextOption,
      help: .init(
        "A list of optional, extra instructions to enable.",
        discussion: ExtraInstruction.allCases
          .map { "(\($0.rawValue)) \($0): \($0.details)" }
          .joined(separator: "\n"),
        valueName: "instructions"
      )
    ) var extraInstructions: [ExtraInstruction] = []
  }
}
