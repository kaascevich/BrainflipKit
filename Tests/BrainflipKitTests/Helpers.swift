// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Foundation
import Testing

import BrainflipKit

func exampleProgram(named name: String) -> String? {
  Bundle.module.url(
    forResource: "Resources/Programs/\(name)",
    withExtension: "bf"
  ).flatMap { url in
    try? String(contentsOf: url, encoding: .utf8)
  }
}
