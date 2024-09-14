// OptimizerTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

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
