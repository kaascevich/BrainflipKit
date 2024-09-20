// Brainflip+Impl.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import ArgumentParser
import BrainflipKit

extension BrainflipCommand {
  func run() async throws {
    // MARK: - Obtaining Source
    
    let programSource = try await chooseProgramSource()
    
    // strip out all comment characters and print the result
    // of that
    if self.printFiltered {
      let filteredSource = programSource.filter(
        Instruction.validInstructions.contains
      )
      print(filteredSource)
      return
    }
    
    // MARK: - Parsing
    
    let parsedProgram = try Program(
      programSource,
      optimizations: self.optimizations
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

    // MARK: Interpreting
    
    let interpreter = Interpreter(
      parsedProgram,
      inputIterator: makeInputIterator(),
      outputStream: IOHelpers.StandardOutputStream(),
      options: makeInterpreterOptions()
    )
    
    // StandardOutputStream prints the output for us, so
    // we don't need to do it ourselves
    _ = try await interpreter.run()
  }
  
  /// Obtains the source code for a Brainflip program from
  /// command-line arguments or standard input.
  ///
  /// - Returns: The source code for the Brainflip program
  ///   provided by the user.
  /// 
  /// - Throws: ``ValidationError`` if both the `--file-path`
  ///   and `-p/--program` options are provided, or if a program
  ///   read from standard input is empty.
  private func chooseProgramSource() async throws(ValidationError) -> String {
    switch (self.programPath, self.program) {
    // if they didn't provide a program or a path to one,
    // read from standard input
    case (nil, nil):
      let input = await IOHelpers.readAllLines()
      guard !input.allSatisfy(\.isWhitespace) else {
        // if they didn't type anything meaningful, just
        // print usage info and exit
        throw ValidationError("")
      }
      return input
      
    // if they provided a program path, read from that
    case (let programPath?, nil):
      // we already checked that this path is valid, so don't bother
      // throwing out
      return try! String(contentsOfFile: programPath, encoding: .utf8) // swiftlint:disable:this force_try

    // if they provided a program, just use that
    case (nil, let program?):
      return program
    
    case (_?, _?):
      throw ValidationError(
        "Only one of 'file-path' or '-p/--program' (or neither) must be provided."
      )
    }
  }

  /// Creates an ``Interpreter/Options`` struct from the
  /// command-line options.
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
      enabledExtraInstructions: Set(self.interpreterOptions.extraInstructions)
    )
  }

  /// Creates an iterator for the interpreter input from
  /// the command-line options.
  /// 
  /// - Returns: An iterator for the interpreter input.
  private func makeInputIterator() -> any IteratorProtocol<Unicode.Scalar> {
    if let input = self.inputOptions.input {
      input.unicodeScalars.makeIterator()
    } else {
      IOHelpers.StandardInputIterator(
        printBell: self.inputOptions.bellOnInputRequest
      )
    }
  }
}
