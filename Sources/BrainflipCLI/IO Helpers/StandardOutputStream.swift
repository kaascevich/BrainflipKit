// StandardOutputStream.swift
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

#if canImport(Glibc)
private import Glibc
#elseif canImport(Darwin.C)
private import Darwin.C
#elseif canImport(WinSDK)
private import WinSDK
#else
#error("Unsupported platform")
#endif

extension IO {
   /// An output stream that prints to standard output
   /// immediately.
   struct StandardOutputStream: TextOutputStream {
      /// Appends the given string to the standard output
      /// stream.
      func write(_ string: String) {
         // For some reason, Swift's `print` function only
         // flushes the output stream after a newline -- even
         // if the `terminator` parameter is altered. So we've
         // gotta do it ourselves.
         print(string, terminator: "")
         fflush(stdout)
      }
   }
}
