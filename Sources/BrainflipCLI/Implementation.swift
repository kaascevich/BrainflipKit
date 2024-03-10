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
      // yeah, this is *really* kind of hacky, but I don't know what
      // else to do
      func runProgram<Encoding: Unicode.Encoding>(_: Encoding.Type) async throws -> String {
         let options = Interpreter<Encoding>.Options(
            arraySize: interpreterOptions.arraySize,
            initialPointerLocation: interpreterOptions.pointerLocation,
            allowCellWraparound: interpreterOptions.wraparound
         )
         let interpreter = Interpreter<Encoding>(program, input: input, options: options)
         return try await interpreter.run()
      }
      
      let output = switch interpreterOptions.cellSize {
      case 8: try await runProgram(UTF8.self)
      case 16: try await runProgram(UTF16.self)
      case 32: try await runProgram(UTF32.self)
      default: throw ValidationError("Invalid cell size -- must be one of 8, 16, or 32")
      }
      
      throw CleanExit.message(output)
   }
}
