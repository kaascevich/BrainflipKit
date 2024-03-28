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

internal enum BrainflipOptimizer {
   static func optimizingWithoutNesting(program: Program) -> Program {
      var program = program
      optimizeClearLoops(in: &program)
      optimizeEmptyLoops(in: &program)
      return program
   }
   
   private static func optimizeClearLoops(in program: inout Program) {
      program.replace([
         .loop([
            .add(-1)
         ])
      ], with: [
         .setTo(0)
      ])
   }
   
   private static func optimizeEmptyLoops(in program: inout Program) {
      program.replace([
         .loop([])
      ], with: [])
   }
}
