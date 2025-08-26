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

/// The standard input file descriptor.
private let standardInput = FileHandle.standardInput.fileDescriptor

extension IOHelpers {
  /// Encapsulates the process of enabling and disabling raw mode for a
  /// terminal.
  enum TerminalRawMode {
    /// Returns a `termios` struct representing the current state of the
    /// terminal.
    ///
    /// - Returns: A `termios` struct representing the current state of the
    ///   terminal.
    private static func getTerminalState() -> termios {
      var currentTerminalState = termios()
      _ = tcgetattr(standardInput, &currentTerminalState)
      return currentTerminalState
    }

    /// Sets the terminal state to the given `termios` struct.
    ///
    /// - Parameter state: A `termios` struct to set the terminal state to.
    private static func setTerminalState(_ state: termios) {
      withUnsafePointer(to: state) {
        _ = tcsetattr(standardInput, TCSAFLUSH, $0)
      }
    }

    /// The original state of the terminal.
    private static let originalTerminalState = getTerminalState()

    /// Enables raw mode.
    ///
    /// - Parameter enableEcho: Whether to echo characters as they are typed.
    static func enable(echoing enableEcho: Bool) {
      var rawTerminalState = originalTerminalState

      // enable raw mode by disabling line buffering
      rawTerminalState.c_lflag &= ~UInt(ICANON)

      if !enableEcho {
        // disable echoing
        rawTerminalState.c_lflag &= ~UInt(ECHO)
      }

      // apply the new settings
      setTerminalState(rawTerminalState)
    }

    /// Disables raw mode.
    static func disable() {
      setTerminalState(originalTerminalState)
    }
  }
}
