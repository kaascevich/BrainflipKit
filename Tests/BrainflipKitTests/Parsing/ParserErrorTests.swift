// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import typealias BrainflipKit.Program

extension ParsingTests {
  @Suite("Parsing errors")
  struct ParserErrorTests {
    @Test("Unpaired loops")
    func unpairedLoops() {
      let invalidPrograms = [
        "[", "]", "][", "]][", "][[", "[][", "][]", "[[]", "[]]",
      ]
      for program in invalidPrograms {
        #expect(throws: Error.self) {
          try Program(program)
        }
      }
    }
  }
}
