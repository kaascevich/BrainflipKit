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
import BrainflipKit

extension BrainflipCommand {
  func run() async throws {
    // MARK: - Obtaining Source

    let programSource = try await chooseProgramSource()

    // strip out all comment characters and print the result of that
    if self.printFiltered {
      let filteredSource = programSource.filter(
        Instruction.validInstructions.contains,
      )
      print(filteredSource)
      return
    }

    // MARK: - Parsing

    let parsedProgram = try Program(
      programSource,
      optimizations: self.optimizations,
    )

    // pretty-print the parsed program
    if self.printParsed {
      let formattedProgram = Self.formatProgram(parsedProgram)
      print(formattedProgram)
      return
    }

    // MARK: - Input

    IOHelpers.TerminalRawMode.enable(echoing: self.inputOptions.inputEchoing)
    defer { IOHelpers.TerminalRawMode.disable() }

    // MARK: - Interpreting

    let interpreter = Interpreter(
      parsedProgram,
      inputIterator: makeInputIterator(),
      outputStream: IOHelpers.StandardOutputStream(),
      options: makeInterpreterOptions(),
    )

    // StandardOutputStream prints the output for us, so we don't need to do it
    // ourselves
    _ = try await interpreter.run()
  }

  /// Obtains the source code for a Brainflip program from command-line
  /// arguments or standard input.
  ///
  /// - Returns: The source code for the Brainflip program provided by the user.
  ///
  /// - Throws: ``ValidationError`` if both the `--file-path` and `-p/--program`
  ///   options are provided, or if a program read from standard input is empty.
  private func chooseProgramSource() async throws(ValidationError) -> String {
    switch (self.programPath, self.program) {
    // if they provided a program path, read from that
    case (let programPath?, nil):
      // we already checked that this path is valid, so don't bother throwing
      // out
      // swiftlint:disable:next force_try
      return try! String(contentsOfFile: programPath, encoding: .utf8)

    // if they provided a program, just use that
    case (nil, let program?):
      return program

    case (_?, _?), (nil, nil):
      throw ValidationError(
        "Exactly one of 'file-path' or '-p/--program' must be specified.",
      )
    }
  }

  /// Creates an ``Interpreter/Options`` struct from the command-line options.
  ///
  /// - Returns: An ``Interpreter/Options`` struct.
  private func makeInterpreterOptions() -> Interpreter.Options {
    let endOfInputBehavior: Interpreter.Options.EndOfInputBehavior? =
      switch self.interpreterOptions.endOfInputBehavior {
      case .zero:  .setTo(0)
      case .max:   .setTo(.max)
      case .error: .throwError
      case  nil:   nil
      }

    return Interpreter.Options(
      allowCellWraparound:      self.interpreterOptions.wraparound,
      endOfInputBehavior:       endOfInputBehavior,
      enabledExtraInstructions: Set(self.interpreterOptions.extraInstructions),
    )
  }

  /// Creates an iterator for the interpreter input from the command-line
  /// options.
  ///
  /// - Returns: An iterator for the interpreter input.
  private func makeInputIterator() -> any IteratorProtocol<Unicode.Scalar> {
    if let input = self.inputOptions.input {
      input.unicodeScalars.makeIterator()
    } else {
      IOHelpers.StandardInputIterator(
        printBell: self.inputOptions.bellOnInputRequest,
      )
    }
  }
}
