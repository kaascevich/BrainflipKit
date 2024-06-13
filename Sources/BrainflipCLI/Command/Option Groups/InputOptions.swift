// InputOptions.swift
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
   struct InputOptions: ParsableArguments {
      @Option(
         name: .shortAndLong,
         help: .init(
            "The input to pass to the program.",
            discussion: """
            If this option is not specified, the input will be read from standard \
            input as the program requests it.
            """
         )
      )
      var input: String?
      
      @Flag(
         inversion: .prefixedNo,
         help: .init(
            "Whether to echo input characters as they are being typed.",
            discussion: """
            This flag has no effect if the '-i/--input' option is specified.
            """
         )
      ) var inputEchoing: Bool = true
      
      @Flag(
         name: .customLong("bell"),
         inversion: .prefixedEnableDisable,
         help: .init(
            "Whether to print a bell character when the program requests input.",
            discussion: """
            This flag has no effect if the '-i/--input' option is specified.
            """
         )
      ) var bellOnInputRequest: Bool = true
   }
}
