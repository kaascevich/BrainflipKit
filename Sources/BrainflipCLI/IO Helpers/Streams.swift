// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation

struct StandardOutputStream: TextOutputStream {
  /// Appends the given string to the standard output stream.
  ///
  /// - Parameter string: The string to print.
  func write(_ string: String) {
    try! FileHandle.standardOutput.write(contentsOf: string.data(using: .utf8)!)
  }
}
