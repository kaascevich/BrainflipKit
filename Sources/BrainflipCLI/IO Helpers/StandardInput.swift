// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation

/// A sequence that reads characters from standard input.
///
/// This sequence enables raw mode for the terminal, which disables line
/// buffering. This allows for reading characters as they are typed, rather than
/// waiting for a newline.
struct StandardInput {
  /// Whether to print a bell character to standard error when input is
  /// requested.
  let printBell: Bool

  /// Creates a new instance of this sequence.
  ///
  /// - Parameter printBell: Whether to print a bell character to standard error
  /// when input is requested.
  init(printBell: Bool) {
    self.printBell = printBell
  }

  /// Whether end of input has been reached.
  private var endOfInput = false
}

extension StandardInput: Sequence, IteratorProtocol {
  mutating func next() -> Unicode.Scalar? {
    guard !endOfInput else { return nil }

    // before any raw mode shenanigans, print a bell character to
    // standard error so the user knows that we want input
    if printBell {
      try? FileHandle.standardError.write(contentsOf: Data([0x07]))
    }

    guard
      let character = try? FileHandle.standardInput.read(upToCount: 1)?.first,
      character != 0x04  // EOF indicator
    else {
      endOfInput = true
      return nil
    }

    return Unicode.Scalar(character)
  }
}
