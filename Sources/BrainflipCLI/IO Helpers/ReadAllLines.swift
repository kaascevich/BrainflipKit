// ReadAllLines.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import struct ArgumentParser.ValidationError

extension IO {
  /// Reads text from standard input until EOF is reached.
  ///
  /// - Returns: Text read from standard input.
  ///
  /// - Throws: `ValidationError` if standard input only
  ///   contains whitespace.
  static func readAllLines() async -> String {
    var input = ""
    while let nextLine = readLine() {
      input += nextLine
      await Task.yield()
    }
    return input
  }
}
