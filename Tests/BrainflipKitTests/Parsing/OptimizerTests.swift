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
   func clearLoopOptimization() async throws {
      let program = try await Program("+[-]")
      #expect(program == [
         .add(1),
         .setTo(0)
      ])
   }
   
   @Test("Adjacent instruction optimization")
   func adjacentInstructionOptimization() async throws {
      let program = try await Program(">>><<+---")
      #expect(program == [
         .move(1),
         .add(-2)
      ])
   }
   
   @Test("Useless instruction optimization")
   func uselessInstructionOptimization() async throws {
      let program = try await Program("+-<> +<>-")
      #expect(program.isEmpty)
   }
   
   @Test("Scan-loop optimization")
   func scanLoopOptimization() async throws {
      let program = try await Program("+[>>>]+[<<]")
      #expect(program == [
         .add(1),
         .scan(3),
         .add(1),
         .scan(-2)
      ])
   }
   
   @Test("Multiply-loop optimization")
   func multiplyLoopOptimization() async throws {
      let program = try await Program("+[- >> ++++ <<]")
      #expect(program == [
         .add(1),
         .multiply(factor: 4, offset: 2)
      ])
   }
   
   @Test("Dead loops optimization")
   func deadLoopsOptimization() async throws {
      do {
         let program = try await Program("+[-][][->+<]")
         #expect(program == [
            .add(1),
            .setTo(0)
         ])
      }
      
      do {
         let program = try await Program("[->+<][-]")
         #expect(program == [
            .multiply(factor: 1, offset: 1)
         ])
      }
   }
}
