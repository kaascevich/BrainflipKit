// StandardInputIterator.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import class Foundation.FileHandle

/// The standard input file descriptor.
private let standardInput = FileHandle.standardInput.fileDescriptor

import struct ArgumentParser.ValidationError

#if canImport(Glibc)
private import Glibc
#elseif canImport(Darwin.C)
private import Darwin.C
#elseif canImport(WinSDK)
private import WinSDK
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
  @available(
    Windows, unavailable, // TODO: Get raw mode working on Windows
    message: "Terminal raw mode on Windows is not yet supported"
  )
  struct StandardInputIterator: IteratorProtocol {
    /// Encapsulates the process of enabling and disabling raw mode
    /// for a terminal.
    private struct TerminalRawMode: ~Copyable {
      /// The original state of the terminal.
      private let originalTerminalState: termios
      
      /// Creates a new instance.
      init() {
        var currentTerminalState = termios()
        _ = tcgetattr(standardInput, &currentTerminalState)
        
        self.originalTerminalState = currentTerminalState
      }
      
      deinit { self.disable() }
      
      /// Enables raw mode.
      ///
      /// - Parameter enableEcho: Whether to echo characters as they are
      ///   typed.
      func enable(echoing enableEcho: Bool) {
        var rawTerminalState = self.originalTerminalState
        
        // enable raw mode by disabling line buffering
        rawTerminalState.c_lflag &= ~UInt(ICANON)
        
        if !enableEcho {
          // disable echoing
          rawTerminalState.c_lflag &= ~UInt(ECHO)
        }
        
        // apply the new settings
        withUnsafePointer(to: rawTerminalState) {
          _ = tcsetattr(standardInput, TCSAFLUSH, $0)
        }
      }
      
      /// Disables raw mode.
      func disable() {
        withUnsafePointer(to: self.originalTerminalState) {
          _ = tcsetattr(standardInput, TCSAFLUSH, $0)
        }
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
      
      let rawMode = TerminalRawMode()
      rawMode.enable(echoing: echo)
      defer { rawMode.disable() }
      
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
