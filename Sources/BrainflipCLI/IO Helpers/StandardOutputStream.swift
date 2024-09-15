// StandardOutputStream.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import class Foundation.FileHandle

extension IOHelpers {
  /// An output stream that prints to standard output
  /// immediately.
  struct StandardOutputStream: TextOutputStream {
    /// Appends the given string to the standard output
    /// stream.
    /// 
    /// - Parameter string: The string to print.
    func write(_ string: String) {
      // we can't use `print()` directly since it only
      // flushes the output stream on a newline. for some
      // reason, using the `standardOutput` file handle
      // provided by Foundation _does_ flush the stream, so
      // we'll just use that instead.
      FileHandle.standardOutput.write(string.data(using: .utf8)!)
    }
  }
}
