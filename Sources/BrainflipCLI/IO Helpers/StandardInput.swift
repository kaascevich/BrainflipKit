// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation

/// A sequence that reads characters from standard input.
///
/// This sequence enables raw mode for the terminal, which disables
/// line buffering. This allows for reading characters as they are
/// typed, rather than waiting for a newline.
struct StandardInput: Sequence, IteratorProtocol {
  /// Whether to print a bell character to standard error when
  /// input is requested.
  let printBell: Bool

  /// Creates a new instance of this sequence.
  ///
  /// - Parameter printBell: Whether to print a bell character
  ///   to standard error when input is requested.
  init(printBell: Bool) {
    self.printBell = printBell
  }

  /// Whether the end of input has been reached.
  private var endOfInput = false

  mutating func next() -> Unicode.Scalar? {
    guard !endOfInput else { return nil }

    // before any raw mode shenanigans, print a bell character to
    // standard error so the user knows that we want input
    if printBell {
      FileHandle.standardError.write(.init([0x07]))
    }

    var nextCharacter: UInt8 = 0
    let readResult = read(
      FileHandle.standardInput.fileDescriptor,
      &nextCharacter,
      1
    )

    // make sure the input request succeeded, and that the character
    // isn't an EOF indicator (0x04)
    guard readResult == 1, nextCharacter != 0x04 else {
      endOfInput = true
      return nil
    }

    return Unicode.Scalar(UInt32(nextCharacter))
  }
}
