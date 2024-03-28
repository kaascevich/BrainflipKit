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

internal enum BrainflipOptimizer {
   static func optimizingWithoutNesting(program: Program) -> Program {
      var program = program
      
      ClearLoopOptimization.optimize(&program)
      ScanLoopOptimization.optimize(&program)
      MultiplyLoopOptimization.optimize(&program)
      
      var previousOptimization: Program
      repeat {
         previousOptimization = program
         AdjacentInstructionOptimization.optimize(&program)
         UselessInstructionOptimization.optimize(&program)
      } while program != previousOptimization
      
      return program
   }
   
   // MARK: - Optimizations
   
   private protocol Optimization {
      static func optimize(_ program: inout Program)
   }

   private enum ClearLoopOptimization: Optimization {
      static func optimize(_ program: inout Program) {
         let clearOperation = [Instruction.setTo(0)]
         program.replace([.loop([.add(-1)])], with: clearOperation)
         program.replace([.loop([.add(+1)])], with: clearOperation)
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
   
   private enum UselessInstructionOptimization: Optimization {
      static func optimize(_ program: inout Program) {
         program.removeAll {
            $0 == .add(0) || $0 == .move(0)
         }
      }
   }
   
   private enum ScanLoopOptimization: Optimization {
      static func optimize(_ program: inout Program) {
         program.replace([.loop([.move(-1)])], with: [.scanLeft])
         program.replace([.loop([.move(+1)])], with: [.scanRight])
      }
   }
   
   private enum MultiplyLoopOptimization: Optimization {
      static func optimize(_ program: inout Program) {
         program = program.map {
            guard
               case let .loop(instructions) = $0,
               instructions.count == 4
            else {
               return $0
            }
            
            let first  = instructions[0]
            let second = instructions[1]
            let third  = instructions[2]
            let fourth = instructions[3]
            
            guard
               case .add(-1) = first,
               case let .move(forwardOffset) = second,
               case let .add(value) = third,
               case let .move(backwardOffset) = fourth,
               
               forwardOffset == -backwardOffset,
               value >= 0
            else {
               return $0
            }
            
            return .multiply(value: .init(value), offset: Int(forwardOffset))
         }
      }
   }
}
