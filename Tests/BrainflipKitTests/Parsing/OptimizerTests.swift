// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import CustomDump
import Testing

@testable import BrainflipKit

@Suite("Program optimization")
struct OptimizerTests {
  @Test("Clear-loop optimization")
  func clearLoopOptimization() throws {
    expectNoDifference(try Program(".[-]"), [.output, .setTo(0)])
    expectNoDifference(try Program("[-]+++"), [.setTo(3)])
    expectNoDifference(try Program("+[-]++"), [.setTo(2)])
    expectNoDifference(try Program("+[-]+++[+]----"), [.setTo(-4)])
  }

  @Test("Adjacent instruction optimization")
  func adjacentInstructionOptimization() throws {
    expectNoDifference(
      try Program(">>><<+---"),
      [
        .move(1),
        .add(-2),
      ]
    )
  }

  @Test("Scan-loop optimization")
  func scanLoopOptimization() throws {
    expectNoDifference(
      try Program("+[>>>]+[<<]"),
      [
        .add(1),
        .scan(3),
        .add(1),
        .scan(-2),
      ]
    )
  }

  @Test("Multiply-loop optimization")
  func multiplyLoopOptimization() throws {
    expectNoDifference(
      try Program("+[- >> ++++ <<]"),
      [
        .add(1),
        .multiply(factor: 4, offset: 2),
      ]
    )
  }

  @Test("Dead loops optimization")
  func deadLoopsOptimization() throws {
    expectNoDifference(try Program("[-][][->+<][>]"), [])
  }
}
