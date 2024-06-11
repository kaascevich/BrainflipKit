// StandardInputIterator.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

import class Foundation.FileHandle
private let standardInput = FileHandle.standardInput.fileDescriptor

import struct ArgumentParser.ValidationError

#if canImport(Glibc)
private import Glibc
#elseif canImport(Darwin.C)
private import Darwin.C
#else
#error("Unsupported platform")
#endif

enum IO {
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
      
      let enableEcho: Bool
      init(echoing enableEcho: Bool) {
         self.enableEcho = enableEcho
      }
      
      func next() -> Unicode.Scalar? {
         // before any raw mode shenanigans, print a bell character so
         // the user knows that we want input
         StandardOutputStream().write("\u{7}")
         
         let rawMode = TerminalRawMode()
         rawMode.enable(echoing: enableEcho)
         defer { rawMode.disable() }
         
         var nextCharacter: UInt8 = 0
         let readResult = read(standardInput, &nextCharacter, 1)
         
         // make sure the input request succeeded, and that the character
         // isn't an EOF indicator (0x04)
         guard readResult == 1, nextCharacter != 0x04 else {
            return nil
         }
         
         return Unicode.Scalar(UInt32(exactly: nextCharacter)!)
      }
   }
}
