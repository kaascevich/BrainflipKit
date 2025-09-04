// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension ParsingTests {
  @Suite("Parsing errors")
  struct ParserErrorTests {
    @Test(
      "Unpaired loops",
      arguments: ["[", "]", "][", "]][", "][[", "[][", "][]", "[[]", "[]]"]
    )
    func unpairedLoops(_ program: String) {
      #expect(
        throws: (any Error).self,
        """
        unpaired loops should fail to parse
        """
      ) {
        try Program(program)
      }
    }
  }
}
