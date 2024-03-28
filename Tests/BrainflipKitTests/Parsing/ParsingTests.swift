// ParsingTests.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

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
            .moveRight(1),
            .increment(1),
            .moveLeft(1),
            .decrement(1),
            .output
         ])
      ])
   }
   
   @Test("Parsing instructions and comments")
   func instructionsAndComments() throws {
      let program = try Program(",++ a comment ++.")
      #expect(program == [
         .input,
         .increment(2),
         .comment(" a comment "),
         .increment(2),
         .output
      ])
   }
   
   @Test("Parsing only comments")
   func commentsOnly() throws {
      let program = try Program("the whole thing is just a comment")
      #expect(program == [
         .comment("the whole thing is just a comment")
      ])
   }
   
   @Test("Parsing nested loops")
   func nestedLoops() throws {
      let program = try Program(">+[>-[-<]>>]>")
      #expect(program == [
         .moveRight(1),
         .increment(1),
         .loop([
            .moveRight(1),
            .decrement(1),
            .loop([
               .decrement(1),
               .moveLeft(1)
            ]),
            .moveRight(2)
         ]),
         .moveRight(1)
      ])
   }
   
   @Test("Extra instructions parsing")
   func extraInstructions() throws {
      let program = try Program("!0~«»?≥≤")
      #expect(program == [
         .extra(.stop),
         .extra(.zero),
         .extra(.bitwiseNot),
         .extra(.leftShift),
         .extra(.rightShift),
         .extra(.random),
         .extra(.nextZero),
         .extra(.prevZero)
      ])
   }
   
   @Test("Set-to parsing")
   func setToInstruction() throws {
      let program = try Program("[-]")
      #expect(program == [.setTo(0)])
   }
   
   @Test("'Obscure Problem Tester'")
   func obscureProblemTester() throws {
      let program = try Program("""
      This program tests for several obscure interpreter problems; it should output an H
      
      []++++++++++[>>+>+>++++++[<<+<+++>>>-]<<<<-]
      "A*$";?@![#>>+<<]>[>>]<<<<[>++<[-]]>.>.
      """)
      #expect(program == [
         .comment("This program tests for several obscure interpreter problems; it should output an H\n\n"),
         .loop([]),
         .increment(10),
         .loop([
            .moveRight(2),
            .increment(1),
            .moveRight(1),
            .increment(1),
            .moveRight(1),
            .increment(6),
            .loop([
               .moveLeft(2),
               .increment(1),
               .moveLeft(1),
               .increment(3),
               .moveRight(3),
               .decrement(1)
            ]),
            .moveLeft(4),
            .decrement(1)
         ]),
         .comment("\n\"A*$\";"),
         .extra(.random),
         .comment("@"),
         .extra(.stop),
         .loop([
            .comment("#"),
            .moveRight(2),
            .increment(1),
            .moveLeft(2)
         ]),
         .moveRight(1),
         .loop([
            .moveRight(2)
         ]),
         .moveLeft(4),
         .loop([
            .moveRight(1),
            .increment(2),
            .moveLeft(1),
            .setTo(0)
         ]),
         .moveRight(1),
         .output,
         .moveRight(1),
         .output
      ])
   }
}
