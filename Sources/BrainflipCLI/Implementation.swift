// Implementation.swift
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

extension BrainflipCLI {
   func run() async throws {
      // MARK: Setup
      
      let endOfInputBehavior = switch self.interpreterOptions.endOfInputBehavior {
      case .zero:  .setTo(0)
      case .max:   .setTo(.max)
      case .error: .throwError
      case  nil:   nil
      } as Interpreter.Options.EndOfInputBehavior?
      
      let options = Interpreter.Options(
         allowCellWraparound:      self.interpreterOptions.wraparound,
         endOfInputBehavior:       endOfInputBehavior,
         enabledExtraInstructions: Set(self.interpreterOptions.extraInstructions)
      )
            
      // MARK: - Obtaining Source
      
      let programSource = try await getProgramSource()
      
      if self.printFiltered {
         let filteredSource = programSource.filter(
            Instruction.validInstructions.contains
         )
         throw CleanExit.message(filteredSource)
      }
      
      // MARK: - Parsing
      
      let parsedProgram = try await Program(
         programSource,
         optimizations: self.optimizations
      )
      
      if self.printParsed {
         let formattedProgram = formatProgram(parsedProgram)
         throw CleanExit.message(formattedProgram)
      }
      
      let inputIterator = if let input {
         input.unicodeScalars.makeIterator()
      } else {
         StandardInputIterator(echoing: self.inputEchoing)
      } as any IteratorProtocol<_>
            
      let interpreter = Interpreter(
         parsedProgram,
         inputIterator: inputIterator,
         outputStream: StandardOutputStream(),
         options: options
      )
      
      // MARK: Interpreting
      
      // StandardOutputStream prints the output for us, so
      // we don't need to do it ourselves
      _ = try await interpreter.run()
   }
}
