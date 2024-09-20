// StandardInputIterator.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Foundation

/// The standard input file descriptor.
private let standardInput = FileHandle.standardInput.fileDescriptor

#if canImport(Glibc)
private import Glibc
#elseif canImport(Darwin.C)
private import Darwin.C
#else
#error("Unsupported platform")
#endif

/// A collection of types for interacting with IO.
enum IOHelpers {
  /// An iterator that reads characters from standard input.
  /// 
  /// This iterator enables raw mode for the terminal, which disables
  /// line buffering. This allows for reading characters as they are
  /// typed, rather than waiting for a newline.
  struct StandardInputIterator: IteratorProtocol {
    /// Encapsulates the process of enabling and disabling raw mode
    /// for a terminal.
    private struct TerminalRawMode: ~Copyable {
      /// Returns a `termios` struct representing the current
      /// state of the terminal.
      /// 
      /// - Returns: A `termios` struct representing the current
      ///   state of the terminal.
      /// 
      /// - Throws: An error if the terminal state could not
      ///   be retrieved.
      private static func getTerminalState() throws -> termios {
        var currentTerminalState = termios()

        let error = tcgetattr(standardInput, &currentTerminalState)
        guard error == 0 else { throw POSIXError(.EIO) }

        return currentTerminalState
      }

      /// Sets the terminal state to the given `termios` struct.
      /// 
      /// - Parameter state: A `termios` struct to set the terminal
      ///   state to.
      /// 
      /// - Throws: An error if the terminal state could not
      ///   be set properly.
      private static func setTerminalState(_ state: termios) throws {
        try withUnsafePointer(to: state) {
          let error = tcsetattr(standardInput, TCSAFLUSH, $0)
          guard error == 0 else { throw POSIXError(.EIO) }
        }
      }

      /// The original state of the terminal.
      private let originalTerminalState: termios
      
      /// Creates a new instance.
      init() throws {
        self.originalTerminalState = try Self.getTerminalState()
      }
      
      deinit { try? self.disable() }
      
      /// Enables raw mode.
      ///
      /// - Parameter enableEcho: Whether to echo characters as they are
      ///   typed.
      /// 
      /// - Throws: An error if the terminal state could not
      ///   be set properly.
      func enable(echoing enableEcho: Bool) throws {
        var rawTerminalState = self.originalTerminalState
        
        // enable raw mode by disabling line buffering
        rawTerminalState.c_lflag &= ~UInt(ICANON)
        
        if !enableEcho {
          // disable echoing
          rawTerminalState.c_lflag &= ~UInt(ECHO)
        }
        
        // apply the new settings
        try Self.setTerminalState(rawTerminalState)
      }
      
      /// Disables raw mode.
      /// 
      /// - Throws: An error if the terminal state could not
      ///   be set properly.
      func disable() throws {
        try Self.setTerminalState(self.originalTerminalState)
      }
    }
    
    /// WWhether to echo characters as they are typed.
    let echo: Bool

    /// Whether to print a bell character to standard error when
    /// input is requested.
    let printBell: Bool
    
    func next() -> Unicode.Scalar? {
      // before any raw mode shenanigans, print a bell character to
      // standard error so the user knows that we want input
      if printBell {
        FileHandle.standardError.write(.init([0x07]))
      }
      
      do {
        let rawMode = try TerminalRawMode()
        try rawMode.enable(echoing: echo)
      } catch { return nil }
      
      var nextCharacter: UInt8 = 0
      let readResult = read(standardInput, &nextCharacter, 1)
      
      // make sure the input request succeeded, and that the character
      // isn't an EOF indicator (0x04)
      guard readResult == 1, nextCharacter != 0x04 else {
        return nil
      }
      
      return Unicode.Scalar(UInt32(nextCharacter))
    }
  }
}
