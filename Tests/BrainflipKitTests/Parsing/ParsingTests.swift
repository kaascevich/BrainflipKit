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
            .nextCell,
            .increment,
            .prevCell,
            .decrement,
            .output
         ])
      ])
      #expect(program.description == ",[>+<-.]")
   }
   
   @Test("Parsing instructions and comments")
   func instructionsAndComments() throws {
      let program = try Program(",++ a comment ++.")
      #expect(program == [
         .input,
         .increment,
         .increment,
         .increment,
         .increment,
         .output
      ])
      #expect(program.description == ",++++.")
   }
   
   @Test("Parsing only comments")
   func commentsOnly() throws {
      let program = try Program("the whole thing is just a comment")
      #expect(program.isEmpty)
      #expect(program.description.isEmpty)
   }
   
   @Test("Parsing nested loops")
   func nestedLoops() throws {
      let program = try Program(">+[>-[-<]>>]>")
      #expect(program == [
         .nextCell,
         .increment,
         .loop([
            .nextCell,
            .decrement,
            .loop([
               .decrement,
               .prevCell
            ]),
            .nextCell,
            .nextCell
         ]),
         .nextCell
      ])
      #expect(program.description == ">+[>-[-<]>>]>")
   }
   
   @Test("Extra instructions parsing")
   func extraInstructions() throws {
      let program = try Program("!0")
      #expect(program == [
         .extra(.stop),
         .extra(.zero)
      ])
      #expect(program.description == "!0")
   }
}
