// Brainflip+Impl.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

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
         
         throw ExitCode.success
      }
      
      // MARK: - Parsing
      
      let parsedProgram = try await Program(
         programSource,
         optimizations: self.optimizations
      )
      
      if self.printParsed {
         let formattedProgram = Self.formatProgram(parsedProgram)
         print(formattedProgram)
         
         throw ExitCode.success
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
   ///   program provided by the user.
   private func chooseProgramSource() async throws -> String {
      switch (self.programPath, self.program) {
      case (nil, nil):
         try await IO.readAllLines()
         
      case (let programPath?, nil):
         try String(contentsOfFile: programPath, encoding: .unicode)
         
      case (nil, let program?):
         program
         
      case (_?, _?):
         throw ValidationError(
            "Only one of 'file-path' or '-p/--program' must be provided."
         )
      }
   }
}
