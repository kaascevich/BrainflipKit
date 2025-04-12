// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

import Testing
@testable import typealias BrainflipKit.Program

@Suite("Program parsing")
struct ParsingTests {
  @Test("Basic parsing")
  func basicParsing() throws {
    let program = try Program(",[>+<-.]")
    #expect(program == [
      .input,
      .loop([
        .move(1),
        .add(1),
        .move(-1),
        .add(-1),
        .output,
      ]),
    ])
  }

  @Test("Parsing instructions and comments")
  func instructionsAndComments() throws {
    let program = try Program(",++ a comment ++.")
    #expect(program == [
      .input,
      .add(4),
      .output,
    ])
  }

  @Test("Parsing only comments")
  func commentsOnly() throws {
    let program = try Program("the whole thing is just a comment")
    #expect(program.isEmpty)
  }

  @Test("Parsing nested loops")
  func nestedLoops() throws {
    let program = try Program(">+[>-[-<]>>]>")
    #expect(program == [
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
    ])
  }

  @Test("Extra instructions parsing")
  func extraInstructions() throws {
    let program = try Program("!~«»?")
    #expect(program == [
      .extra(.stop),
      .extra(.bitwiseNot),
      .extra(.leftShift),
      .extra(.rightShift),
      .extra(.random),
    ])
  }

  @Test("'Obscure Problem Tester'")
  func obscureProblemTester() throws {
    let program = try Program("""
    This program tests for several obscure interpreter problems;
    it should output an H

    []++++++++++[>>+>+>++++++[<<+<+++>>>-]<<<<-]
    "A*$";?@![#>>+<<]>[>>]<<<<[>++<[-]]>.>.
    """)
    #expect(program == [
      .loop([]),
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
      .extra(.random),
      .extra(.stop),
      .loop([
        .move(2),
        .add(1),
        .move(-2),
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
    ])
  }

  @Test("Optimizations disabled")
  func optimizationsDisabled() throws { // swiftlint:disable:this function_body_length
    let program = try Program("""
    This program tests for several obscure interpreter problems;
    it should output an H

    []++++++++++[>>+>+>++++++[<<+<+++>>>-]<<<<-]
    "A*$";?@![#>>+<<]>[>>]<<<<[>++<[-]]>.>.
    """, optimizations: false)
    #expect(program == [
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
      .extra(.random),
      .extra(.stop),
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
    ])
  }
}
