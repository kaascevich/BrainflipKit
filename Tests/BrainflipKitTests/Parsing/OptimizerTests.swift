// OptimizerTests.swift
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

import Testing
@testable import typealias BrainflipKit.Program

@Suite("Program optimization")
struct OptimizerTests {
   @Test("Clear-loop optimization")
   func clearLoopOptimization() throws {
      var program = try Program("[-]")
      #expect(program == [.setTo(0)])
      
      program = try Program("[+]")
      #expect(program == [.setTo(0)])
   }
   
   @Test("Adjacent instruction optimization")
   func adjacentInstructionOptimization() throws {
      let program = try Program(">>><<+---")
      #expect(program == [
         .move(1),
         .add(-2)
      ])
   }
   
   @Test("Useless instruction optimization")
   func uselessInstructionOptimization() throws {
      let program = try Program("+-<> +<>-")
      #expect(program.isEmpty)
   }
}
