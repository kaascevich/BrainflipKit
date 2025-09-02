// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser
import BrainflipKit

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
      let endOfInputBehavior: InterpreterOptions.EndOfInputBehavior? =
        switch interpreterOptions.endOfInputBehavior {
        case .zero: .setTo(0)
        case .max: .setTo(.max)
        case .error: .throwError
        case nil: nil
        }

      return InterpreterOptions(
        allowCellWraparound: interpreterOptions.wraparound,
        endOfInputBehavior: endOfInputBehavior
      )
    }

    func run() throws {
      let parsedProgram = try programOptions.parseProgram()

      TerminalRawMode.enable(echoing: inputOptions.inputEchoing)
      defer { TerminalRawMode.disable() }

      let inputSequence: any Sequence<Unicode.Scalar> =
        if let input = inputOptions.input {
          input.unicodeScalars
        } else {
          StandardInput(printBell: inputOptions.bellOnInputRequest)
        }

      let interpreter = Interpreter(
        input: AnySequence(inputSequence),
        output: StandardOutputStream(),
        options: makeInterpreterOptions()
      )

      // StandardOutputStream prints the output for us, so we don't need to do
      // it ourselves.
      _ = try interpreter.run(parsedProgram)
    }
  }
}
