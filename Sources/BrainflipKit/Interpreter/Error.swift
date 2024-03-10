// Error.swift
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

public extension Interpreter {
   /// Represents an error that can happen during the
   /// lifetime of an ``Interpreter``.
   enum Error: Swift.Error {
      /// Indicates that the cell pointer went out of the
      /// bounds of the array.
      case cellPointerOutOfBounds
      
      /// Indicates that the current cell value overflowed.
      case cellOverflow
      
      /// Indicates that the current cell value underflowed.
      case cellUnderflow
   }
}

extension Interpreter.Error: CustomStringConvertible {
   /// A description of this error.
   public var description: String {
      switch self {
      case .cellPointerOutOfBounds: "Cell pointer went out of bounds"
         
      case .cellOverflow: "Cell overflowed"
      case .cellUnderflow: "Cell underflowed"
      }
   }
}
