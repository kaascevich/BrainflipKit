// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

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
