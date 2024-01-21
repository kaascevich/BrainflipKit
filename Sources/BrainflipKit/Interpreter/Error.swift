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

import Foundation
import OSLog

public extension Interpreter {
   /// Represents an error that can happen during the
   /// lifetime of an ``Interpreter``.
   enum Error: Swift.Error {
      /// Indicates that an unpaired loop instruction was
      /// found.
      case unpairedLoopInstruction(Instruction.LoopBound)
      
      /// Indicates that an illegal character was found
      /// in the input buffer.
      case illegalCharacterInInput(Character)
      
      /// Indicates that there are no instructions left
      /// to execute.
      case noInstructionsRemaining
      
      /// Creates an `Error`, logging its `errorDescription`
      /// in the process.
      internal init(logging error: Self) {
         Logger.interpreter.error("\(error.description)")
         self = error
      }
   }
}

extension Interpreter.Error: CustomStringConvertible {
   /// A description of this error.
   public var description: String {
      switch self {
         case .unpairedLoopInstruction(.begin):
            "unpaired loop(begin) instruction found"
         case .unpairedLoopInstruction(.end):
            "unpaired loop(end) instruction found"
            
         case .illegalCharacterInInput(let character):
            "illegal character found in input: '\(character)'"
            
         case .noInstructionsRemaining:
            "no instructions left to execute"
      }
   }
}
