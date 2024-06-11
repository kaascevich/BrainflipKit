// StringFromStandardInput.swift
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

import struct ArgumentParser.ValidationError

extension IO {
   /// Reads text from standard input until EOF is reached.
   ///
   /// - Returns: Text read from standard input.
   ///
   /// - Throws: `ValidationError` if standard input only
   ///   contains whitespace.
   static func stringFromStandardInput() async throws -> String {
      var input = ""
      while let nextLine = readLine() {
         input += nextLine
      }
      
      if input.allSatisfy(\.isWhitespace) {
         // if they didn't type anything meaningful, just
         // print usage info and exit
         throw ValidationError("")
      }
      
      return input
   }
}
