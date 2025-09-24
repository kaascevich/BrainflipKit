// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation

extension FileHandle: @retroactive TextOutputStream {
  /// Appends the given string to the file handle.
  ///
  /// - Parameter string: The string to write.
  func write(_ string: String) {
    try! write(contentsOf: string.data(using: .utf8)!)
  }
}
