// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

import typealias BrainflipKit.Program

extension BrainflipCommand {
  /// Formats the given program, indenting loops.
  ///
  /// - Parameters:
  ///   - program: The program to format.
  ///   - indentLevel: The level of indentation to apply.
  ///
  /// - Returns: A formatted program.
  static func formatProgram(_ program: Program, indentLevel: Int = 0) -> String {
    var lines: [String] = []

    let indent = String(repeating: "  ", count: indentLevel)

    for instruction in program {
      let linesToAppend = switch instruction {
      case .loop(let instructions): [
        indent + "loop(",
        // don't apply any indent here, because that'll be redundant
        formatProgram(instructions, indentLevel: indentLevel + 1),
        indent + ")",
      ]

      // output the instruction's details
      default: [indent + String(describing: instruction)]
      }

      lines += linesToAppend
    }

    return lines.joined(separator: "\n")
  }
}
