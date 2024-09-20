// Brainflip+Helpers.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

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
