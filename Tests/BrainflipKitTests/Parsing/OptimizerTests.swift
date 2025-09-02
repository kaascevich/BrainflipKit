// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import typealias BrainflipKit.Program

@Suite("Program optimization")
struct OptimizerTests {
  @Test("Clear-loop optimization")
  func clearLoopOptimization() throws {
    #expect(try Program(".[-]") == [.output, .setTo(0)])
    #expect(try Program("[-]+++") == [.setTo(3)])
    #expect(try Program("+[-]++") == [.setTo(2)])
    #expect(try Program("+[-]+++[+]----") == [.setTo(-4)])
  }

  @Test("Adjacent instruction optimization")
  func adjacentInstructionOptimization() throws {
    #expect(
      try Program(">>><<+---") == [
        .move(1),
        .add(-2),
      ]
    )
  }

  @Test("Useless instruction optimization")
  func uselessInstructionOptimization() throws {
    #expect(try Program("+-<> +<>-").isEmpty)
  }

  @Test("Scan-loop optimization")
  func scanLoopOptimization() throws {
    #expect(
      try Program("+[>>>]+[<<]") == [
        .add(1),
        .scan(3),
        .add(1),
        .scan(-2),
      ]
    )
  }

  @Test("Multiply-loop optimization")
  func multiplyLoopOptimization() throws {
    #expect(
      try Program("+[- >> ++++ <<]") == [
        .add(1),
        .multiply(factor: 4, offset: 2),
      ]
    )
  }

  @Test("Dead loops optimization")
  func deadLoopsOptimization() throws {
    #expect(try Program("+[-][][->+<]").isEmpty)
  }
}
