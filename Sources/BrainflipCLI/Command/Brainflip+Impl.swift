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
    // MARK: Setup
    
    let endOfInputBehavior: Interpreter.Options.EndOfInputBehavior? =
      switch self.interpreterOptions.endOfInputBehavior {
      case .zero:  .setTo(0)
      case .max:   .setTo(.max)
      case .error: .throwError
      case  nil:   nil
      }
    
    let options = Interpreter.Options(
      allowCellWraparound:      self.interpreterOptions.wraparound,
      endOfInputBehavior:       endOfInputBehavior,
      enabledExtraInstructions: Set(self.interpreterOptions.extraInstructions)
    )
        
    // MARK: - Obtaining Source
    
    let programSource = try await chooseProgramSource()
    
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
    
    if self.printParsed {
      let formattedProgram = Self.formatProgram(parsedProgram)
      print(formattedProgram)
      
      return
    }
    
    let inputIterator: any IteratorProtocol<_> =
      if let input = self.inputOptions.input {
        input.unicodeScalars.makeIterator()
      } else {
        IO.StandardInputIterator(
          echo: self.inputOptions.inputEchoing,
          printBell: self.inputOptions.bellOnInputRequest
        )
      }
        
    let interpreter = Interpreter(
      parsedProgram,
      inputIterator: inputIterator,
      outputStream: IO.StandardOutputStream(),
      options: options
    )
    
    // MARK: Interpreting
    
    // StandardOutputStream prints the output for us, so
    // we don't need to do it ourselves
    _ = try await interpreter.run()
  }
  
  /// Obtains the source code for a Brainflip program
  /// from command-line arguments or standard input.
  ///
  /// - Returns: The source code for the Brainflip
  ///  program provided by the user.
  private func chooseProgramSource() async throws -> String {
    switch (self.programPath, self.program) {
    case (nil, nil):
      let input = await IO.readAllLines()
      guard !input.allSatisfy(\.isWhitespace) else {
        // if they didn't type anything meaningful, just
        // print usage info and exit
        throw ValidationError("")
      }
      return input
      
    case (let programPath?, nil):
      return try String(contentsOfFile: programPath, encoding: .unicode)
      
    case (nil, let program?):
      return program
      
    case (_?, _?):
      throw ValidationError(
        "Only one of 'file-path' or '-p/--program' (or neither) must be provided."
      )
    }
  }
}
