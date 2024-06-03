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
   func basicParsing() async throws {
      let program = try await Program(",[>+<-.]")
      #expect(program == [
         .input,
         .loop([
            .move(1),
            .add(1),
            .move(-1),
            .add(-1),
            .output
         ])
      ])
   }
   
   @Test("Parsing instructions and comments")
   func instructionsAndComments() async throws {
      let program = try await Program(",++ a comment ++.")
      #expect(program == [
         .input,
         .add(4),
         .output
      ])
   }
   
   @Test("Parsing only comments")
   func commentsOnly() async throws {
      let program = try await Program("the whole thing is just a comment")
      #expect(program.isEmpty)
   }
   
   @Test("Parsing nested loops")
   func nestedLoops() async throws {
      let program = try await Program(">+[>-[-<]>>]>")
      #expect(program == [
         .move(1),
         .add(1),
         .loop([
            .move(1),
            .add(-1),
            .loop([
               .add(-1),
               .move(-1)
            ]),
            .move(2)
         ]),
         .move(1)
      ])
   }
   
   @Test("Extra instructions parsing")
   func extraInstructions() async throws {
      let program = try await Program("!~«»?")
      #expect(program == [
         .extra(.stop),
         .extra(.bitwiseNot),
         .extra(.leftShift),
         .extra(.rightShift),
         .extra(.random)
      ])
   }
   
   @Test("'Obscure Problem Tester'")
   func obscureProblemTester() async throws {
      let program = try await Program("""
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
               .add(-1)
            ]),
            .move(-4),
            .add(-1)
         ]),
         .extra(.random),
         .extra(.stop),
         .loop([
            .move(2),
            .add(1),
            .move(-2)
         ]),
         .move(1),
         .scan(2),
         .move(-4),
         .loop([
            .move(1),
            .add(2),
            .move(-1),
            .setTo(0)
         ]),
         .move(1),
         .output,
         .move(1),
         .output
      ])
   }
   
   @Test("Optimizations disabled")
   func optimizationsDisabled() async throws {
      let program = try await Program("""
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
               .add(-1)
            ]),
            .move(-1), .move(-1), .move(-1), .move(-1),
            .add(-1)
         ]),
         .extra(.random),
         .extra(.stop),
         .loop([
            .move(1), .move(1),
            .add(1),
            .move(-1), .move(-1)
         ]),
         .move(1),
         .loop([
            .move(1), .move(1)
         ]),
         .move(-1), .move(-1), .move(-1), .move(-1),
         .loop([
            .move(1),
            .add(1), .add(1),
            .move(-1),
            .loop([.add(-1)])
         ]),
         .move(1),
         .output,
         .move(1),
         .output
      ])
   }
}
