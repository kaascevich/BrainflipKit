// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

import Foundation

/// A collection of types for interacting with IO.
enum IOHelpers {
  /// An iterator that reads characters from standard input.
  ///
  /// This iterator enables raw mode for the terminal, which disables
  /// line buffering. This allows for reading characters as they are
  /// typed, rather than waiting for a newline.
  struct StandardInputIterator: IteratorProtocol {
    /// Whether to print a bell character to standard error when
    /// input is requested.
    let printBell: Bool

    /// Creates a new instance of this iterator.
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
}
