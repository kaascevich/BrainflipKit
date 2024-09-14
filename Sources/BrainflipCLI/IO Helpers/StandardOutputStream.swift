// StandardOutputStream.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

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
