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

  @Test("Useless instruction optimization")
  func uselessInstructionOptimization() throws {
    expectNoDifference(try Program("+-<> +<>-"), [])
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

  @Test("Life")
  func life() throws {
    expectNoDifference(
      try getProgram(named: "life"),
      [
        .move(3), .add(-1),
        .move(1), .add(1),
        .move(1), .add(5),
        .move(1), .add(10),
        .loop([
          .multiply(factor: 1, offset: 3),
          .move(1), .add(5),
          .move(1), .add(1),
          .move(2), .add(1),
          .loop([
            .move(-2), .add(1),
            .move(5), .add(1),
            .move(-3), .add(-1),
          ]),
          .move(-1), .add(-1),
        ]),
        .move(4),
        .loop([
          .loop([
            .move(3), .add(1),
            .move(1), .add(1),
            .move(-4), .add(-1),
          ]),
          .add(3),
          .move(2), .add(1),
          .loop([
            .move(-1), .add(1),
            .move(3), .add(1),
            .move(1), .add(1),
            .move(-3), .add(-1),
          ]),
          .move(2),
          .loop([
            .move(1),
            .loop([.multiply(factor: 1, offset: 3), .move(-1)]),
            .move(-2), .add(2),
            .move(1), .add(1),
            .move(6), .add(-1),
          ]),
          .move(-1), .add(-1),
        ]),
        .add(3),
        .move(1),
        .add(1),
        .move(1),
        .loop([
          .setTo(0),
          .move(-1), .add(1),
          .move(-1), .multiply(factor: 17, offset: 1),
          .move(-1), .add(1),
        ]),
        .move(2),
        .loop([
          .loop([
            .add(9),
            .output,
            .add(-8),
            .move(3),
          ]),
          .add(1),
          .loop([.add(-1), .move(-3)]),
          .move(3),
          .loop([
            .move(2),
            .input,
            .add(-10),
            .scan(1),
            .move(-1),
          ]),
          .move(-2),
          .loop([
            .move(-3),
            .loop([
              .move(1), .add(-2),
              .loop([
                .move(-1), .add(-1),
                .move(2), .add(1),
                .move(1), .add(-1),
                .move(-2), .add(-1),
              ]),
              .move(-1),
              .loop([
                .scan(3), .add(1),
                .move(1), .add(-1),
                .loop([
                  .add(1),
                  .move(2), .add(1),
                  .move(1), .add(-1),
                ]),
                .add(1),
                .scan(-3),
                .move(-1), .add(-1),
              ]),
              .move(1), .add(2),
              .move(1), .multiply(factor: 1, offset: -1),
              .move(1),
              .loop([
                .scan(3),
                .add(1),
                .scan(-3),
                .move(3), .add(-1),
              ]),
              .add(1),
              .loop([.add(-1), .move(3)]),
              .move(-1),
              .add(-1),
              .loop([.add(2), .move(1)]),
              .move(1),
              .loop([.add(-6), .move(-1)]),
              .move(1),
              .add(3),
              .scan(-3),
              .move(1),
            ]),
            .move(-1),
          ]),
          .move(1),
          .loop([
            .add(-1),
            .loop([
              .add(1),
              .move(2), .add(1),
              .move(1), .add(-1),
            ]),
            .add(1),
            .move(2), .add(1),
            .move(3), .add(1),
            .move(1), .scan(-3),
            .move(1), .add(-1),
            .move(1), .add(1),
            .move(1),
            .loop([
              .move(1),
              .loop([
                .add(-1),
                .move(1), .add(1),
                .move(1), .add(3),
                .move(2), .add(2),
                .scan(3), .add(3),
                .move(-3), .add(2),
                .move(-3), .add(2),
                .scan(3),
                .move(3),
              ]),
              .move(-3),
              .loop([
                .move(1),
                .scan(3),
                .add(1),
                .move(3),
              ]),
              .move(-7),
              .loop([
                .move(-2), .add(2),
                .move(-1), .add(1),
                .loop([.add(-1), .move(-3), .add(1)]),
                .add(-1),
                .move(1), .add(2),
                .move(3), .add(2),
                .move(3), .add(2),
                .move(-4),
              ]),
              .move(-3),
              .add(1),
              .loop([.add(-1), .move(-3), .add(1)]),
              .add(1),
              .move(1), .add(-1),
              .move(2), .add(-1),
              .move(2),
            ]),
            .move(-2), .add(1),
            .move(-2), .add(1),
            .move(-3), .add(1),
            .move(-2), .add(-1),
            .loop([
              .add(1),
              .move(-1), .add(1),
              .move(-2), .add(-1),
            ]),
            .add(1),
            .move(-1), .add(1),
            .loop([
              .add(-1),
              .move(1), .add(1),
              .move(1),
              .loop([
                .add(-1),
                .move(-1), .add(-1),
                .move(-2),
                .scan(-3),
                .move(1),
                .loop([
                  .move(2),
                  .scan(3),
                  .move(-2), .add(1),
                  .move(-1),
                  .scan(-3),
                  .move(1), .add(-1),
                ]),
              ]),
              .move(-1),
              .loop([
                .move(-1),
                .loop([
                  .move(-1),
                  .scan(-3),
                  .move(1), .add(1),
                  .move(2),
                  .scan(3),
                  .move(-2), .add(-1),
                ]),
                .move(-1),
                .scan(-3),
              ]),
              .move(3), .add(-1),
              .move(3),
              .scan(3),
              .add(1),
              .move(1),
            ]),
            .move(1), .add(1),
            .loop([
              .add(-1),
              .move(-2),
              .setTo(0),
              .move(-1),
            ]),
            .add(-1),
            .loop([
              .scan(3),
              .move(-1),
              .loop([
                .move(-2),
                .scan(-3),
                .move(5), .add(1),
                .move(1),
                .scan(3),
                .move(-1), .add(-1),
              ]),
              .move(3),
              .loop([
                .move(1),
                .scan(3),
                .move(-4), .add(1),
                .move(1),
                .scan(-3),
                .move(2), .add(-1),
              ]),
              .move(1),
            ]),
            .move(-6),
            .loop([
              .add(-3),
              .move(-1), .add(-5),
              .loop([
                .add(-1),
                .loop([
                  .add(-1),
                  .loop([
                    .move(-1), .add(-1),
                    .move(2), .add(3),
                    .move(-1), .setTo(0),
                  ]),
                ]),
              ]),
              .move(-1), .add(1),
              .move(-1), .add(1),
            ]),
            .move(1),
          ]),
          .move(2),
        ]),
      ]
    )
  }
}
