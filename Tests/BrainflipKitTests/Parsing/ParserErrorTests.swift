// ParserErrorTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import Testing
@testable import typealias BrainflipKit.Program

extension ParsingTests {
  @Suite("Parsing errors")
  struct ParserErrorTests {
    @Test("Unpaired loops")
    func unpairedLoops() async {
      let invalidPrograms = [
        "[", "]", "][", "]][", "][[", "[][", "][]", "[[]", "[]]"
      ]
      for program in invalidPrograms {
        await #expect(throws: (any Error).self) {
          try await Program(program)
        }
      }
    }
  }
}
