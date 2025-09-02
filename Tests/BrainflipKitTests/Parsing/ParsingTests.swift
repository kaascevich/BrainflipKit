// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Testing

@testable import typealias BrainflipKit.Program

@Suite("Program parsing")
struct ParsingTests {
  let hTest = """
    This program tests for several obscure interpreter problems;
    it should output an H

    []++++++++++[>>+>+>++++++[<<+<+++>>>-]<<<<-]
    "A*$";?@![#>>+<<]>[>>]<<<<[>++<[-]]>.>.
    """

  @Test("Basic parsing")
  func basicParsing() throws {
    #expect(
      try Program(",[>+<-.]") == [
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
    #expect(
      try Program(",++ a comment ++.") == [
        .input,
        .add(4),
        .output,
      ]
    )

    #expect(try Program("the whole thing is just a comment").isEmpty)
  }

  @Test("Parsing nested loops")
  func nestedLoops() throws {
    #expect(
      try Program(">+[>-[-<]>>]>") == [
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
    #expect(
      try Program(hTest) == [
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

  @Test("Optimizations disabled")
  func optimizationsDisabled() throws {
    #expect(
      try Program(hTest, optimizations: false) == [
        .loop([]),
        .add(1), .add(1), .add(1), .add(1), .add(1),
        .add(1), .add(1), .add(1), .add(1), .add(1),
        .loop([
          .move(1), .move(1),
          .add(1),
          .move(1),
          .add(1),
          .move(1),
          .add(1), .add(1), .add(1),
          .add(1), .add(1), .add(1),
          .loop([
            .move(-1), .move(-1),
            .add(1),
            .move(-1),
            .add(1), .add(1), .add(1),
            .move(1), .move(1), .move(1),
            .add(-1),
          ]),
          .move(-1), .move(-1), .move(-1), .move(-1),
          .add(-1),
        ]),
        .loop([
          .move(1), .move(1),
          .add(1),
          .move(-1), .move(-1),
        ]),
        .move(1),
        .loop([.move(1), .move(1)]),
        .move(-1), .move(-1), .move(-1), .move(-1),
        .loop([
          .move(1),
          .add(1), .add(1),
          .move(-1),
          .loop([.add(-1)]),
        ]),
        .move(1),
        .output,
        .move(1),
        .output,
      ]
    )
  }
}
