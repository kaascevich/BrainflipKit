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
      switch ($0, $1) {
      case (.add, .add), (.move, .move): true
      default: false
      }
    }

    self = chunks.flatMap { chunk in
      // we only need to check the first value, since all others should
      // match it
      let casePath: _? =
        switch chunk.first {
        case .add: \Instruction.Cases.add
        case .move: \Instruction.Cases.move
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
      return if sum == 0 { [] } else { [casePath(sum)] }
    }
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
      if case .add(-1) = instructions[0],
        case let .move(offset) = instructions[1],
        case let .add(factor) = instructions[2],
        case .move(-offset) = instructions[3]
      {
        self[index] = .multiply(factor: factor, offset: offset)
      } else if case let .move(offset) = instructions[0],
        case let .add(factor) = instructions[1],
        case .move(-offset) = instructions[2],
        case .add(-1) = instructions[3]
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

  /// Removes a loop from the start of the program.
  ///
  /// Doesn't bother removing more than 1 loop, since the others should have
  /// already been optimized away by this point.
  private mutating func removeInitialLoops() {
    if self.first?.isLoopLike == true {
      self.removeFirst()
    }
  }

  // MARK: - Main Optimizer

  /// Optimizes this program.
  private mutating func optimizeNested() {
    removeDeadLoops()

    for case (let index, .loop(var instructions)) in indexed() {
      instructions.optimizeNested()
      self[index] = .loop(instructions)
    }

    var previousOptimization: Program
    repeat {
      previousOptimization = self
      removeAdjacentInstructions()
      removeDeadLoops()
    } while self != previousOptimization

    optimizeClearLoops()
    optimizeScanLoops()
    optimizeMultiplyLoops()
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
    switch self {
    case .loop, .multiply, .scan, .setTo(0): true
    default: false
    }
  }
}
