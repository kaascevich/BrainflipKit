// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Algorithms
import CasePaths

extension Program {
  // MARK: - Optimizations

  /// Condenses clear loops.
  ///
  /// This optimization condenses clear loops into a single `setTo(0)`
  /// instruction. If there's an `add` instruction following the clear loop, the
  /// value of that instruction is used in the `setTo` instruction instead of 0,
  /// and the `add` instruction is removed.
  private mutating func optimizeClearLoops() {
    // MARK: [-]/[+] -> setTo(0)
    for case let (index, .loop(instructions)) in indexed()
    where instructions == [.add(1)] || instructions == [.add(-1)] {
      self[index] = .setTo(0)
    }

    // MARK: setTo(lhs) add(rhs) -> setTo(lhs + rhs)
    // check if the first instruction is a clear loop
    // and the second is an `add` instruction
    for case let (
      (firstIndex, .setTo(lhs)),
      (secondIndex, .add(rhs))
    ) in indexed().adjacentPairs().reversed() {
      remove(at: secondIndex)
      self[firstIndex] = .setTo(lhs + rhs)
    }

    // MARK: add(_) setTo(rhs) -> setTo(rhs)
    for case let (
      (index, first),
      (_, .setTo)
    ) in indexed().adjacentPairs().reversed()
    where first.is(\.add) || first.is(\.setTo) {
      remove(at: index)
    }
  }

  /// Removes adjacent instructions of the same type.
  private mutating func removeAdjacentInstructions() {
    let chunks = chunked {
      ($0.is(\.add) && $1.is(\.add)) || ($0.is(\.move) && $1.is(\.move))
    }

    self = chunks.flatMap { chunk in
      // we only need to check the first value, since all others should
      // match it
      let casePath: CaseKeyPath<Instruction, CellValue>? =
        switch chunk.first {
        case .add: \.add
        case .move: \.move
        default: nil
        }

      // make sure we're actually dealing with one of the cases we're
      // interested in optimizing
      guard let casePath else {
        return chunk
      }

      // condense all the values into a single instruction
      let values = chunk.map(\.[case: casePath]!)
      let sum = values.reduce(0, +)
      return [casePath(sum)]
    }
  }

  /// Removes useless instructions from the program.
  private mutating func removeUselessInstructions() {
    removeAll { $0 == .add(0) || $0 == .move(0) }
  }

  /// Optimizes scan loops.
  private mutating func optimizeScanLoops() {
    for case let (index, .loop(instructions)) in indexed()
    where instructions.count == 1 {
      if case let .move(increment) = instructions[0] {
        self[index] = .scan(increment)
      }
    }
  }

  /// Optimizes multiplication loops.
  private mutating func optimizeMultiplyLoops() {
    for case let (index, .loop(instructions)) in indexed()
    where instructions.count == 4 {
      // check if the loop's instructions match what we're looking for
      if instructions[0] == .add(-1),
        case let .move(offset) = instructions[1],
        case let .add(factor) = instructions[2],
        instructions[3] == .move(-offset)
      {
        self[index] = .multiply(factor: factor, offset: offset)
      } else if case let .move(offset) = instructions[0],
        case let .add(factor) = instructions[1],
        instructions[2] == .move(-offset),
        instructions[3] == .add(-1)
      {
        self[index] = .multiply(factor: factor, offset: offset)
      }
    }
  }

  /// Removes loops that will never be executed.
  ///
  /// In Brainflip, loops will only start (or continue) looping if the current
  /// cell is not zero. This means that, for the instruction directly after a
  /// loop, the current cell will always be 0. If that instruction happens to
  /// also be a loop, that loop will never be executed. So we remove those loops
  /// here.
  private mutating func removeDeadLoops() {
    for case let ((_, first), (secondIndex, second))
      in indexed().adjacentPairs().reversed()
    where first.isLoopLike && second.isLoopLike {
      // there's a loop immediately after another loop, so the second loop will
      // never be executed (because the current cell is always 0 immediately
      // after a loop)
      remove(at: secondIndex)
    }
  }

  // MARK: - Root Optimizations

  /// Removes loops from the start of the program.
  private mutating func removeInitialLoops() {
    self = Program(self.drop(while: \.isLoopLike))
  }

  // MARK: - Main Optimizer

  /// Optimizes this program.
  private mutating func optimizeNested() {
    for case (let index, .loop(var instructions)) in indexed() {
      instructions.optimizeNested()
      self[index] = .loop(instructions)
    }

    var previousOptimization: Program
    repeat {
      previousOptimization = self
      removeAdjacentInstructions()
      removeUselessInstructions()
      removeDeadLoops()
    } while self != previousOptimization

    optimizeClearLoops()
    optimizeScanLoops()
    optimizeMultiplyLoops()
    removeDeadLoops()
  }

  /// Optimizes this program.
  mutating func optimize() {
    optimizeNested()
    removeInitialLoops()
  }
}

// MARK: - Utilities

extension Instruction {
  fileprivate var isLoopLike: Bool {
    self.is(\.loop)
      || self.is(\.multiply)
      || self.is(\.scan)
      || self == .setTo(0)
  }
}
