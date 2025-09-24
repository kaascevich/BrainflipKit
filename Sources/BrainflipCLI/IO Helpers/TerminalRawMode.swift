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

  /// The original state of the terminal.
  private static let originalTerminalState = terminalState

  /// Enables raw mode.
  ///
  /// - Parameter enableEcho: Whether to echo characters as they are typed.
  static func enable(echoing enableEcho: Bool) {
    // disable line buffering
    terminalState.c_lflag &= ~UInt(ICANON)

    if !enableEcho {
      // disable echoing
      terminalState.c_lflag &= ~UInt(ECHO)
    }
  }

  /// Disables raw mode.
  static func disable() {
    terminalState = originalTerminalState
  }
}
