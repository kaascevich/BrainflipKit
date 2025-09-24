// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import CustomDump
import Testing

@testable import BrainflipKit

@Suite struct `Program parsing` {
  @Test func `Basic parsing`() throws {
    expectNoDifference(
      try Program(",[>+<-.]"),
      [
        .input,
        .loop([
          .move(1),
          .add(1),
          .move(-1),
          .add(-1),
          .output,
        ]),
      ]
    )
  }

  @Test func `Parsing instructions and comments`() throws {
    expectNoDifference(
      try Program(",++ a comment ++."),
      [
        .input,
        .add(4),
        .output,
      ]
    )

    expectNoDifference(try Program("the whole thing is just a comment"), [])
  }

  @Test func `Parsing nested loops`() throws {
    expectNoDifference(
      try Program(">+[>-[-<]>>]>"),
      [
        .move(1),
        .add(1),
        .loop([
          .move(1),
          .add(-1),
          .loop([
            .add(-1),
            .move(-1),
          ]),
          .move(2),
        ]),
        .move(1),
      ]
    )
  }

  @Test func `'Obscure Problem Tester'`() throws {
    expectNoDifference(
      try getProgram(named: "obscure"),
      [
        .add(10),
        .loop([
          .move(2),
          .add(1),
          .move(1),
          .add(1),
          .move(1),
          .add(6),
          .multiply([-2: 1, -3: 3]),
          .move(-4),
          .add(-1),
        ]),
        .move(1),
        .loop([.move(2)]),
        .move(-4),
        .loop([
          .move(1),
          .add(2),
          .move(-1),
          .setTo(0),
        ]),
        .move(1),
        .output,
        .move(1),
        .output,
      ]
    )
  }
}
