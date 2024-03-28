// Optimizer.swift
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
import Algorithms
import CasePaths

private protocol Optimization {
   static func optimize(_ program: inout Program)
}

internal enum BrainflipOptimizer {
   static func optimizingWithoutNesting(program: Program) -> Program {
      var program = program
      ClearLoopOptimization.optimize(&program)
      AdjacentInstructionOptimization.optimize(&program)
      return program
   }
   
   private enum ClearLoopOptimization: Optimization {
      static func optimize(_ program: inout Program) {
         program.replace([
            .loop([
               .add(-1)
            ])
         ], with: [
            .setTo(0)
         ])
      }
   }
   
   private enum AdjacentInstructionOptimization: Optimization {
      static func optimize(_ program: inout Program) {
         program = program.chunked {
            switch ($0, $1) {
               // we only care about these two instruction types
            case (.add, .add), (.move, .move): true
            default: false
            }
         }.flatMap { chunk in
            // we only need to check the first value, since all others
            // should match it
            let casePath: CaseKeyPath<Instruction, Int32>? = switch chunk.first {
            case .add:  \Instruction.Cases.add
            case .move: \Instruction.Cases.move
            default: nil
            }
            
            // make sure we're actually dealing with one of the
            // cases we're interested in optimizing
            guard let casePath else {
               return chunk
            }
            
            let values = chunk.map { $0[case: casePath]! }
            let sum = values.reduce(0, +)
            return [casePath(sum)]
         }
      }
   }
}