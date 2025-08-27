// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import class Foundation.FileHandle

extension IOHelpers {
  /// An output stream that prints to standard output immediately.
  struct StandardOutputStream: TextOutputStream {
    /// Appends the given string to the standard output stream.
    ///
    /// - Parameter string: The string to print.
    func write(_ string: String) {
      // We can't use `print()` directly since it only flushes the output stream
      // on a newline. For some reason, using the `standardOutput` file handle
      // provided by Foundation _does_ flush the stream, so we'll just use that
      // instead.
      FileHandle.standardOutput.write(string.data(using: .utf8)!)
    }
  }
}
