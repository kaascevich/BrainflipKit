// TerminalRawMode.swift
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
private let standardInputDescriptor = FileHandle.standardInput.fileDescriptor

#if canImport(Glibc)
private import Glibc
#elseif canImport(Darwin.C)
private import Darwin.C
#endif

extension BrainflipCLI {
   /// Encapsulates the process of enabling and disabling raw mode
   /// for a terminal.
   struct TerminalRawMode: ~Copyable {
      /// The original state of the terminal.
      private let originalTerminalState: termios
      
      /// Creates a new instance.
      init() {
         self.originalTerminalState = {
            var currentTerminalState = termios()
            withUnsafeMutablePointer(to: &currentTerminalState) {
               _ = tcgetattr(standardInputDescriptor, $0)
            }
            return currentTerminalState
         }()
      }
      
      deinit {
         self.disable()
      }
      
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
         _ = tcsetattr(standardInputDescriptor, TCSAFLUSH, &rawTerminalState)
      }
      
      /// Disables raw mode.
      func disable() {
         withUnsafePointer(to: self.originalTerminalState) {
            _ = tcsetattr(standardInputDescriptor, TCSAFLUSH, $0)
         }
      }
   }
}
