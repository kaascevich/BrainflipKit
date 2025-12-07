// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser
import BrainflipKit
import Foundation

extension Brainflip {
  struct Run: ParsableCommand {
    // MARK: - Command Configuration

    static let configuration = CommandConfiguration(
      abstract: "Runs a brainfuck program."
    )

    // MARK: - Option Groups

    @OptionGroup(title: "Program Options")
    var programOptions: ProgramOptionGroup

    @OptionGroup(title: "Input Options")
    var inputOptions: InputOptionGroup

    @OptionGroup(title: "Interpreter Options")
    var interpreterOptions: InterpreterOptionGroup

    // MARK: - Implementation

    /// Creates an ``InterpreterOptions`` struct from the command-line options.
    ///
    /// - Returns: An ``InterpreterOptions`` struct.
    private func makeInterpreterOptions() -> InterpreterOptions {
      let endOfInputBehavior: InterpreterOptions.EndOfInputBehavior =
        switch interpreterOptions.endOfInputBehavior {
        case .zero: .setTo(0)
        case .max: .setTo(.max)
        case nil: .doNothing
        }

      return InterpreterOptions(endOfInputBehavior: endOfInputBehavior)
    }

    func run() throws {
      let parsedProgram = try programOptions.parseProgram()

      TerminalRawMode.withRawModeEnabled(echoing: inputOptions.inputEchoing) {
        let inputSequence: any Sequence<_> =
          if let input = inputOptions.input {
            input.unicodeScalars
          } else {
            StandardInput(printBell: inputOptions.bellOnInputRequest)
          }

        let interpreter = Interpreter(
          input: AnySequence(inputSequence),
          output: FileHandle.standardOutput,
          options: makeInterpreterOptions()
        )

        // StandardOutput prints the output for us, so we don't need to do it
        // ourselves
        _ = interpreter.run(parsedProgram)
      }
    }
  }
}
