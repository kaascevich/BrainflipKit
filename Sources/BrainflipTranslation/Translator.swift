// SPDX-FileCopyrightText: 2025 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

public import BrainflipKit

public protocol Translator {
  init(options: InterpreterOptions, strictCompatibility: Bool)

  func translate(program: Program) async throws -> String
}	
