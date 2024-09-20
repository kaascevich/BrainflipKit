// ExtraInstruction+Argument.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import protocol ArgumentParser.ExpressibleByArgument
import enum BrainflipKit.ExtraInstruction

extension ExtraInstruction: @retroactive ExpressibleByArgument {
  /// Parses an `ExtraInstruction` from an argument.
  /// 
  /// - Parameter argument: The argument to parse.
  public init?(argument: String) {
    let `case` = Self.allCases.first { String(describing: $0) == argument }
    guard let `case` else { return nil }
    
    self = `case`
  }
  
  /// Every case of `ExtraInstruction`, represented as strings.
  public static let allValueStrings = allCases.map(String.init(describing:))
  
  /// A detailed description of this instruction.
  public var details: String {
    switch self {
    case .stop: "Immediately ends the program."
    case .bitwiseNot: "Performs a bitwise NOT on the current cell."
    case .leftShift: "Performs a lossy left bit-shift on the current cell."
    case .rightShift: "Performs a lossy right bit-shift on the current cell."
    case .random: "Sets the current cell to a random value."
    }
  }
}
