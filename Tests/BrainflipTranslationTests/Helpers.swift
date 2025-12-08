// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation

@testable import BrainflipKit

func getProgram(named name: String) throws -> Program {
  let url = #bundle.url(forResource: name, withExtension: "b")!
  let source = try String(contentsOf: url, encoding: .utf8)
  return try Program(source)
}
