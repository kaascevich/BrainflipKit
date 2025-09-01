// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import typealias BrainflipKit.Program

extension ParsingTests {
  @Suite("Parsing errors") struct ParserErrorTests {
    @Test("Unpaired loops", arguments: [
      "[", "]", "][", "]][", "][[", "[][", "][]", "[[]", "[]]",
      try #require(getProgram(named: "unmatchedleft")),
      try #require(getProgram(named: "unmatchedright")),
    ])
    func unpairedLoops(_ program: String) {
      #expect(throws: (any Error).self) {
        try Program(program)
      }
    }
  }
}
