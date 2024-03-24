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
      let caseNames = zip(Self.allCases, Self.allValueStrings)
      let caseName = caseNames.first { $0.1 == argument }
      
      guard let caseName else { return nil }
      self = caseName.0
   }
   
   public static var allValueStrings: [String] {
      allCases.map(String.init(describing:))
   }
   
   public var details: (name: String, rawValue: Character, description: String) {
      let description = switch self {
      case .stop: "Immediately ends the program."
      case .zero: "Sets the current cell to zero."
      }
      
      return (name: String(describing: self), self.rawValue, description)
   }
}
