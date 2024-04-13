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
   /// lifetime of an ``Interpreter`` instance.
   enum Error: Swift.Error, Equatable, Hashable {
      /// Indicates that the cell value at the specified
      /// `position` overflowed.
      case cellOverflow(position: Int)
      
      /// Indicates that the cell value at the specified
      /// `position` underflowed.
      case cellUnderflow(position: Int)
      
      /// Indicates that the input iterator was exhausted.
      case endOfInput
      
      /// Indicates that the program was ended by a
      /// ``ExtraInstruction/stop`` instruction.
      case stopInstruction
   }
}

extension Interpreter.Error: CustomStringConvertible {
   /// A description of this error.
   public var description: String {
      switch self {
      case .cellOverflow(let position):
         "The cell at position \(position) overflowed."
      
      case .cellUnderflow(let position):
         "The cell at position \(position) underflowed."
         
      case .endOfInput:
         "Executed an input instruction after end-of-input was reached."
         
      case .stopInstruction:
         "Encountered a stop instruction."
      }
   }
}

extension Interpreter {
   func checkOverflowAllowed(throwing error: Error) throws {
      guard options.allowCellWraparound else {
         throw error
      }
   }
}
