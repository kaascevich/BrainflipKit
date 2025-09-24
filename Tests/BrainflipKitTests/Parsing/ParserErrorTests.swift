// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import BrainflipKit

extension `Program parsing` {
  @Suite struct `Parsing errors` {
    /// Unpaired loops fail to parse.
    @Test(arguments: ["[", "]", "][", "]][", "][[", "[][", "][]", "[[]", "[]]"])
    func `Unpaired loops`(_ program: String) {
      #expect(throws: (any Error).self) {
        try Program(program)
      }
    }
  }
}
