// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation

/// The standard input file descriptor.
private let standardInput = FileHandle.standardInput.fileDescriptor

/// Encapsulates the process of enabling and disabling raw mode for a
/// terminal.
enum TerminalRawMode {
  private static var terminalState: termios {
    get {
      var currentState = termios()
      _ = unsafe tcgetattr(standardInput, &currentState)
      return currentState
    }

    set {
      unsafe withUnsafePointer(to: newValue) {
        _ = unsafe tcsetattr(standardInput, TCSAFLUSH, $0)
      }
    }
  }

  /// Enables raw mode for the duration of a closure.
  ///
  /// - Parameters:
  ///   - enableEcho: Whether to echo characters as they are typed.
  ///   - body: The closure to execute.
  ///
  /// - Returns: The closure's return value.
  static func withRawModeEnabled<T, E: Error>(
    echoing enableEcho: Bool,
    do body: () throws(E) -> T
  ) throws(E) -> T {
    let originalTerminalState = terminalState

    // disable line buffering
    terminalState.c_lflag &= ~UInt(ICANON)

    if !enableEcho {
      // disable echoing
      terminalState.c_lflag &= ~UInt(ECHO)
    }

    defer {
      // restore the original terminal settings
      terminalState = originalTerminalState
    }

    return try body()
  }
}
