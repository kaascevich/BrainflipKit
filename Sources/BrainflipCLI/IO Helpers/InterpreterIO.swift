// InterpreterIO.swift
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

import ArgumentParser

#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

extension BrainflipCLI {
   struct StandardInputIterator: IteratorProtocol {
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

         var nextCharacter: UInt8 = 0
         let readResult = read(
            FileHandle.standardInput.fileDescriptor,
            &nextCharacter,
            1
         )
         
         // make sure the input request succeeded, and that the character
         // isn't an EOF indicator (0x04)
         guard readResult == 1, nextCharacter != 0x04 else {
            return nil
         }
         
         return Unicode.Scalar(UInt32(exactly: nextCharacter)!)
      }
   }
   
   /// An output stream that prints to standard output
   /// immediately.
   struct StandardOutputStream: TextOutputStream {
      /// Appends the given string to the standard output
      /// stream.
      func write(_ string: String) {
         print(string, terminator: "")
         fflush(stdout) // flush the stream
      }
   }
}
