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

@Suite("Program optimization")
struct OptimizerTests {
  @Test("Clear-loop optimization")
  func clearLoopOptimization() throws {
    let program = try Program("+[-]")
    #expect(program == [
      .add(1),
      .setTo(0),
    ])
  }

  @Test("Adjacent instruction optimization")
  func adjacentInstructionOptimization() throws {
    let program = try Program(">>><<+---")
    #expect(program == [
      .move(1),
      .add(-2),
    ])
  }

  @Test("Useless instruction optimization")
  func uselessInstructionOptimization() throws {
    let program = try Program("+-<> +<>-")
    #expect(program.isEmpty)
  }

  @Test("Scan-loop optimization")
  func scanLoopOptimization() throws {
    let program = try Program("+[>>>]+[<<]")
    #expect(program == [
      .add(1),
      .scan(3),
      .add(1),
      .scan(-2),
    ])
  }

  @Test("Multiply-loop optimization")
  func multiplyLoopOptimization() throws {
    let program = try Program("+[- >> ++++ <<]")
    #expect(program == [
      .add(1),
      .multiply(factor: 4, offset: 2),
    ])
  }

  @Test("Dead loops optimization")
  func deadLoopsOptimization() throws {
    do {
      let program = try Program("+[-][][->+<]")
      #expect(program == [
        .add(1),
        .setTo(0),
      ])
    }

    do {
      let program = try Program("[->+<][-]")
      #expect(program == [
        .multiply(factor: 1, offset: 1),
      ])
    }
  }
}
