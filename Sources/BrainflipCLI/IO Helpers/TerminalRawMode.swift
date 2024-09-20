// TerminalRawMode.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Foundation

/// The standard input file descriptor.
private let standardInput = FileHandle.standardInput.fileDescriptor

extension IOHelpers {
  /// Encapsulates the process of enabling and disabling raw mode
  /// for a terminal.
  enum TerminalRawMode {
    /// Returns a `termios` struct representing the current
    /// state of the terminal.
    /// 
    /// - Returns: A `termios` struct representing the current
    ///   state of the terminal.
    private static func getTerminalState() -> termios {
      var currentTerminalState = termios()
      _ = tcgetattr(standardInput, &currentTerminalState)
      return currentTerminalState
    }

    /// Sets the terminal state to the given `termios` struct.
    /// 
    /// - Parameter state: A `termios` struct to set the terminal
    ///   state to.
    private static func setTerminalState(_ state: termios) {
      withUnsafePointer(to: state) {
        _ = tcsetattr(standardInput, TCSAFLUSH, $0)
      }
    }

    /// The original state of the terminal.
    private static let originalTerminalState = getTerminalState()
    
    /// Enables raw mode.
    ///
    /// - Parameter enableEcho: Whether to echo characters as they are
    ///   typed.
    static func enable(echoing enableEcho: Bool) {
      var rawTerminalState = self.originalTerminalState
      
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
      setTerminalState(self.originalTerminalState)
    }
  }
}
