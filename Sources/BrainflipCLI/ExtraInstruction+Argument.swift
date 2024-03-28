// ExtraInstruction+Argument.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

import ArgumentParser
import BrainflipKit

extension ExtraInstruction: ExpressibleByArgument {
   public init?(argument: String) {
      let caseName = Self.allCases.first { String(describing: $0) == argument }
      guard let caseName else { return nil }
      
      self = caseName
   }
   
   public static let allValueStrings = allCases.map(String.init(describing:))
   
   public var details: String {
      switch self {
      case .stop: "Immediately ends the program."
      case .zero: "Sets the current cell to zero."
      case .bitwiseNot: "Performs a bitwise NOT on the current cell."
      case .leftShift: "Performs a lossy left bit-shift on the current cell."
      case .rightShift: "Performs a lossy right bit-shift on the current cell."
      case .random: "Sets the current cell to a random value."
      case .nextZero: "Moves the pointer to the next zero cell."
      case .prevZero: "Moves the pointer to the previous zero cell."
      }
   }
}
