// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation

@testable import BrainflipKit

func getProgram(named name: String) -> String? {
  Bundle.module.url(forResource: name, withExtension: "b")
    .flatMap { url in
      try? String(contentsOf: url, encoding: .utf8)
    }
}

extension Program: ExpressibleByArrayLiteral {
  public init(arrayLiteral instructions: Instruction...) {
    self.init(instructions)
  }
}
