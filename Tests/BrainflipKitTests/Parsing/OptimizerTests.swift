// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import typealias BrainflipKit.Program

@Suite("Program optimization") struct OptimizerTests {
  @Test("Clear-loop optimization")
  func clearLoopOptimization() throws {
    let program = try Program("+[-]+++[+]----")
    #expect(program == [.setTo(-4)])
  }

  @Test("Adjacent instruction optimization")
  func adjacentInstructionOptimization() throws {
    let program = try Program(">>><<+---")
    #expect(
      program == [
        .move(1),
        .add(-2),
      ]
    )
  }

  @Test("Useless instruction optimization")
  func uselessInstructionOptimization() throws {
    let program = try Program("+-<> +<>-")
    #expect(program.isEmpty)
  }

  @Test("Scan-loop optimization")
  func scanLoopOptimization() throws {
    let program = try Program("+[>>>]+[<<]")
    #expect(
      program == [
        .add(1),
        .scan(3),
        .add(1),
        .scan(-2),
      ]
    )
  }

  @Test("Multiply-loop optimization")
  func multiplyLoopOptimization() throws {
    let program = try Program("+[- >> ++++ <<]")
    #expect(
      program == [
        .add(1),
        .multiply(factor: 4, offset: 2),
      ]
    )
  }

  @Test("Dead loops optimization")
  func deadLoopsOptimization() throws {
    let program = try Program("+[-][][->+<]")
    #expect(program == [.setTo(0)])
  }
}
