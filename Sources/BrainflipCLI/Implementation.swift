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
      
      let endOfInputBehavior = switch interpreterOptions.endOfInputBehavior {
      case .zero:  .setTo(0)
      case .max:   .setTo(.max)
      case .error: .throwError
      case  nil:   nil
      } as Interpreter.Options.EndOfInputBehavior?
      
      let options = Interpreter.Options(
         allowCellWraparound:      interpreterOptions.wraparound,
         endOfInputBehavior:       endOfInputBehavior,
         enabledExtraInstructions: Set(interpreterOptions.extraInstructions)
      )
            
      // MARK: - Parsing
      
      let programSource = try await getProgramSource()
      let parsedProgram = try Program(
         programSource,
         optimizations: optimizations
      )
      
      if printParsed {
         let formattedProgram = formatProgram(parsedProgram)
         print(formattedProgram)
         Self.exit()
      }
      
      let interpreter = Interpreter(
         parsedProgram,
         input: input,
         options: options
      )
      
      // MARK: Interpreting
      
      let output = try await interpreter.run()
      
      print(output)
      Self.exit()
   }
}
