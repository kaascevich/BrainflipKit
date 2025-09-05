// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import CustomDump
import Testing

@testable import BrainflipKit

@Suite("Program parsing")
struct ParsingTests {
  @Test("Basic parsing")
  func basicParsing() throws {
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

  @Test("Parsing instructions and comments")
  func instructionsAndComments() throws {
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

  @Test("Parsing nested loops")
  func nestedLoops() throws {
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

  @Test("'Obscure Problem Tester'")
  func obscureProblemTester() throws {
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
          .loop([
            .move(-2),
            .add(1),
            .move(-1),
            .add(3),
            .move(3),
            .add(-1),
          ]),
          .move(-4),
          .add(-1),
        ]),
        .move(1),
        .scan(2),
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
