// ErrorChecking.swift
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

import OSLog

public extension Interpreter {
   /// Checks the ``Interpreter/program`` for errors.
   func checkProgram() async throws {
      Logger.interpreter.info("checking program for errors...")
      try await checkLoops()
      Logger.interpreter.info("no errors found in program, continuing")
   }
   
   /// Checks the ``Interpreter/program`` to ensure that
   /// all loops are closed -- that is, that every
   /// `loop(.begin)` instruction has a corresponding
   /// `loop(.end)` instruction.
   ///
   /// - Throws: ``Error/unpairedLoopInstruction(_:)``.
   internal func checkLoops() async throws {
      Logger.interpreter.info("checking loops...")
      
      var currentNestingLevel = 0
      
      // this filters out non-loop instructions
      for case let .loop(boundType) in self.program {
         switch boundType {
            case .begin:
               currentNestingLevel += 1
               
            case .end:
               guard currentNestingLevel != 0 else {
                  // found an unpaired loop(end) instruction
                  throw Error(logging: .unpairedLoopInstruction(.end))
               }
               currentNestingLevel -= 1
         }
      }
      
      guard currentNestingLevel == 0 else {
         // not all loop(begin) instructions are paired
         throw Error(logging: .unpairedLoopInstruction(.begin))
      }
      
      Logger.interpreter.info("loops OK")
   }
}
