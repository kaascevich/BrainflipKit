// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import BrainflipKit
import CustomDump
import Testing

@testable import BrainflipTranslation

@Suite struct SwiftTranslatorTests {
  @Test func `Simple translation`() throws {
    let program = try getProgram(named: "simple")
    let translator = SwiftTranslator(options: .init())
    let translated = translator.translate(program: program)
    expectNoDifference(
      translated,
      """
      #!/usr/bin/env swift
      import Foundation
      // MARK: Raw Mode
      var currentState = termios()
      _ = unsafe tcgetattr(FileHandle.standardInput.fileDescriptor, &currentState)
      currentState.c_lflag &= ~numericCast(ICANON)
      unsafe withUnsafePointer(to: currentState) {
          _ = unsafe tcsetattr(FileHandle.standardInput.fileDescriptor, TCSAFLUSH, $0)
      }
      // MARK: Declarations
      // give the program a small buffer, in case it goes off the start of the tape
      var array = [Int](repeating: 0, count: 31_000)
      var pointer: Int = 1_000
      func output() {
          if let scalar = Unicode.Scalar(array[pointer]) {
              try! FileHandle.standardOutput.write(
                  contentsOf: String(scalar).data(using: .utf8)!
              )
          }
      }
      func input() {
          if let character = try? FileHandle.standardInput.read(upToCount: 1)?.first {
              array[pointer] = numericCast(Unicode.Scalar(character).value)
          } else {
          }
      }
      input()
      while array[pointer] != 0 {
          pointer &+= 1
          array[pointer] &+= 1
          pointer &-= 1
          array[pointer] &-= 1
          output()
      }
      """
    )
  }

  @Test func `Simple translation with strict compatibility`() throws {
    let program = try getProgram(named: "simple")
    let translator = SwiftTranslator(options: .init())
    let translated = translator.translate(
      program: program,
      strictCompatibility: true
    )
    expectNoDifference(
      translated,
      """
      #!/usr/bin/env swift
      import Foundation
      // MARK: Raw Mode
      var currentState = termios()
      _ = unsafe tcgetattr(FileHandle.standardInput.fileDescriptor, &currentState)
      currentState.c_lflag &= ~numericCast(ICANON)
      unsafe withUnsafePointer(to: currentState) {
          _ = unsafe tcsetattr(FileHandle.standardInput.fileDescriptor, TCSAFLUSH, $0)
      }
      // MARK: Declarations
      // give the program a small buffer, in case it goes off the start of the tape
      var array = [UInt8](repeating: 0, count: 31_000)
      var pointer: Int = 1_000
      func output() {
          try! FileHandle.standardOutput.write(
              contentsOf: String(Unicode.Scalar(array[pointer]))
                  .data(using: .utf8)!
          )
      }
      func input() {
          if let character = try? FileHandle.standardInput.read(upToCount: 1)?.first {
              array[pointer] = numericCast(Unicode.Scalar(character).value)
          } else {
          }
      }
      input()
      while array[pointer] != 0 {
          pointer &+= 1
          array[pointer] &+= 1
          pointer &-= 1
          array[pointer] &-= 1
          output()
      }
      """
    )
  }
}
