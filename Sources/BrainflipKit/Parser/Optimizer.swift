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

private import Algorithms
import CasePaths

internal extension Program {
   enum Optimizer {
      // MARK: - Optimizations
      private static func optimizeClearLoops(_ program: inout Program) {
         let clearOperation = [Instruction.setTo(0)]
         program.replace([.loop([.add(-1)])], with: clearOperation)
      }
      
      private static func removeAdjacentInstructions(_ program: inout Program) {
         program = program.chunked {
            switch ($0, $1) {
               // we only care about these two instruction types
            case (.add, .add), (.move, .move): true
            default: false
            }
         }.flatMap { chunk in
            // we only need to check the first value, since all others
            // should match it
            let casePath: _? = switch chunk.first {
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
      
      private static func removeUselessInstructions(_ program: inout Program) {
         program.removeAll {
            $0 == .add(0) || $0 == .move(0)
         }
      }
      
      private static func optimizeScanLoops(_ program: inout Program) {
         program.replace([.loop([.move(-1)])], with: [.scanLeft])
         program.replace([.loop([.move(+1)])], with: [.scanRight])
      }
      
      private static func optimizeMultiplyLoops(_ program: inout Program) {
         program = program.map {
            guard
               case let .loop(instructions) = $0,
               instructions.count == 4
            else { return $0 }
            
            // check if the loop's instructions match what
            // we're looking for
            guard
               case     .add(-1)       = instructions[0],
               case let .move(offset)  = instructions[1],
               case let .add(factor)   = instructions[2],
               case     .move(-offset) = instructions[3],
               factor >= 0
            else { return $0 }
            
            return .multiply(
               factor: .init(factor),
               offset: Int(offset)
            )
         }
      }
      
      private static func removeDeadLoops(_ program: inout Program) {
         let windows = [_](program.enumerated()).windows(ofCount: 2)
         var indicesToRemove: [Int] = []
         for window in windows {
            if
               case .loop = window.first?.element,
               case .loop = window.last?.element
            {
               // there's a loop immediately after another loop, so the second
               // loop will never be executed (because the current cell is
               // always 0 immediately after a loop)
               indicesToRemove.append(window.last!.offset)
            }
         }
         
         // remove indices from last to first, so as not
         // to invalidate indices before we've used them
         for index in indicesToRemove.reversed() {
            program.remove(at: index)
         }
      }
      
      // MARK: - Main Optimizer
      
      static func optimizingWithoutNesting(_ program: Program) -> Program {
         var program = program
         
         removeDeadLoops(&program)
         
         var previousOptimization: Program
         repeat {
            previousOptimization = program
            removeAdjacentInstructions(&program)
            removeUselessInstructions(&program)
         } while program != previousOptimization
         
         optimizeClearLoops(&program)
         optimizeScanLoops(&program)
         optimizeMultiplyLoops(&program)
         
         return program
      }
   }
}

#if swift(<6.0)

extension KeyPath: @unchecked Sendable
where Root: Sendable, Value: Sendable { }

extension Instruction.AllCasePaths: @unchecked Sendable { }

#else
#warning("Sendable extensions for KeyPath are redundant in Swift 6 and newer")
#endif
