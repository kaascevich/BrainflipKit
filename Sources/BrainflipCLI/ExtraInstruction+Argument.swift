// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

import protocol ArgumentParser.ExpressibleByArgument
import enum BrainflipKit.ExtraInstruction

extension ExtraInstruction: ExpressibleByArgument {
  /// Parses an `ExtraInstruction` from an argument.
  ///
  /// - Parameter argument: The argument to parse.
  public init?(argument: String) {
    let instruction = Self.allCases.first { String(describing: $0) == argument }
    guard let instruction else { return nil }

    self = instruction
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
