// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import CustomDump
import Testing

@testable import BrainflipKit

@Suite struct `Program optimization` {
  @Test func `Adjacent instruction optimization`() throws {
    expectNoDifference(
      try Program(">>><<+---"),
      [
        .move(1),
        .add(-2),
      ]
    )
  }

  @Test func `Useless instruction optimization`() throws {
    expectNoDifference(try Program("+-<> +-+- ><>< +<>-"), [])
  }

  @Test func `Multiply instruction optimization`() throws {
    expectNoDifference(
      try Program("+[- >> ++++ <<]"),
      [.add(1), .multiply([2: 4])]
    )

    expectNoDifference(try Program(".[-]."), [.output, .setTo(0), .output])
    expectNoDifference(try Program("[-]+++"), [.setTo(3)])
    expectNoDifference(try Program("+[-]++"), [.setTo(2)])
    expectNoDifference(try Program("+[-]+++[-]----"), [.setTo(-4)])

    expectNoDifference(
      try Program("+++[>+++>++<<-]"),
      [
        .add(3),
        .multiply([1: 3, 2: 2]),
      ]
    )
  }

  @Test func `Dead loops optimization`() throws {
    expectNoDifference(try Program("[-][][->+<][>]"), [])
  }

  @Test func `Life`() throws {
    expectNoDifference(
      try getProgram(named: "life"),
      [
        .move(3), .add(-1),
        .move(1), .add(1),
        .move(1), .add(5),
        .move(1), .add(10),
        .loop([
          .multiply([3: 1]),
          .move(1), .add(5),
          .move(1), .add(1),
          .move(2), .add(1),
          .multiply([-2: 1, 3: 1]),
          .move(-1), .add(-1),
        ]),
        .move(4),
        .loop([
          .multiply([3: 1, 4: 1], final: 3),
          .move(2), .add(1),
          .multiply([-1: 1, 2: 1, 3: 1]),
          .move(2),
          .loop([
            .move(1),
            .loop([
              .multiply([3: 1]),
              .move(-1),
            ]),
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
          .move(-1), .multiply([1: 17]),
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
            .loop([.move(1)]),
            .move(-1),
          ]),
          .move(-2),
          .loop([
            .move(-3),
            .loop([
              .move(1), .add(-2),
              .multiply([-1: -1, 1: 1, 2: -1]),
              .move(-1),
              .loop([
                .loop([.move(3)]), .add(1),
                .move(1), .add(-1),
                .loop([
                  .add(1),
                  .move(2), .add(1),
                  .move(1), .add(-1),
                ]),
                .add(1),
                .loop([.move(-3)]),
                .move(-1), .add(-1),
              ]),
              .move(1), .add(2),
              .move(1), .multiply([-1: 1]),
              .move(1),
              .loop([
                .loop([.move(3)]),
                .add(1),
                .loop([.move(-3)]),
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
              .loop([.move(-3)]),
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
            .move(1), .loop([.move(-3)]),
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
                .loop([.move(3)]), .add(3),
                .move(-3), .add(2),
                .move(-3), .add(2),
                .loop([.move(3)]),
                .move(3),
              ]),
              .move(-3),
              .loop([
                .move(1),
                .loop([.move(3)]),
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
                .loop([.move(-3)]),
                .move(1),
                .loop([
                  .move(2),
                  .loop([.move(3)]),
                  .move(-2), .add(1),
                  .move(-1),
                  .loop([.move(-3)]),
                  .move(1), .add(-1),
                ]),
              ]),
              .move(-1),
              .loop([
                .move(-1),
                .loop([
                  .move(-1),
                  .loop([.move(-3)]),
                  .move(1), .add(1),
                  .move(2),
                  .loop([.move(3)]),
                  .move(-2), .add(-1),
                ]),
                .move(-1),
                .loop([.move(-3)]),
              ]),
              .move(3), .add(-1),
              .move(3),
              .loop([.move(3)]),
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
              .loop([.move(3)]),
              .move(-1),
              .loop([
                .move(-2),
                .loop([.move(-3)]),
                .move(5), .add(1),
                .move(1),
                .loop([.move(3)]),
                .move(-1), .add(-1),
              ]),
              .move(3),
              .loop([
                .move(1),
                .loop([.move(3)]),
                .move(-4), .add(1),
                .move(1),
                .loop([.move(-3)]),
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
                    .move(-1),
                    .setTo(0),
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
