// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Algorithms
import CasePaths

extension [Instruction] {
  // MARK: - Optimizations

  /// Removes adjacent instructions of the same type.
  private mutating func removeAdjacentInstructions() {
    let chunks = chunked {
      switch ($0, $1) {
      case (.add, .add), (.move, .move): true
      default: false
      }
    }

    self = chunks.flatMap { (chunk: ArraySlice<Instruction>) in
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
      let sum = values.reduce(0, &+)
      return if sum == 0 { [] } else { [casePath(sum)] }
    }
  }

  /// Optimizes multiply instructions.
  private mutating func optimizeMultiplyInstructions() {
    top: for case let (index, .loop(instructions)) in indexed() {
      var currentOffset: CellOffset = 0
      var multiplications: [CellOffset: CellValue] = [:]

      for instruction in instructions {
        switch instruction {
        case let .add(value):
          multiplications[currentOffset, default: 0] &+= value

        case let .move(offset):
          currentOffset &+= offset

        case .loop, .input, .output, .multiply:
          continue top
        }
      }

      guard currentOffset == 0, multiplications[0] == -1 else {
        continue top
      }

      multiplications[0] = nil
      self[index] = .multiply(multiplications)
    }

    // MARK: multiply(_, final) add(value) -> multiply(_, final + value)
    for case let (
      (firstIndex, .multiply(multiplications, final)),
      (secondIndex, .add(value))
    ) in indexed().adjacentPairs().reversed() {
      remove(at: secondIndex)
      self[firstIndex] = .multiply(multiplications, final: final &+ value)
    }

    // MARK: add(_) multiply([:], final) -> multiply([:], final)
    for case let (
      (index, first),
      (_, .multiply([:], final: _))
    ) in indexed().adjacentPairs().reversed() {
      switch first {
      case .add, .multiply([:], final: _):
        remove(at: index)

      default: break
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
    for case let ((_, .loop), (secondIndex, .loop))
      in indexed().adjacentPairs().reversed() {
      // there's a loop immediately after another loop, so the second loop will
      // never be executed (because the current cell is always 0 immediately
      // after a loop)
      remove(at: secondIndex)
    }
  }

  // MARK: - Main Optimizer

  /// Optimizes this program.
  fileprivate mutating func optimizeNested() {
    var previousOptimization: [Instruction]
    repeat {
      previousOptimization = self
      removeAdjacentInstructions()
      removeDeadLoops()
    } while self != previousOptimization

    for case (let index, .loop(var instructions)) in indexed() {
      instructions.optimizeNested()
      self[index] = .loop(instructions)
    }

    optimizeMultiplyInstructions()
  }
}

// MARK: - Root Optimizations

extension Program {
  /// Removes a loop from the start of the program.
  ///
  /// Doesn't bother removing more than 1 loop, since the others should have
  /// already been optimized away by this point.
  private mutating func removeInitialLoops() {
    if instructions.first?.isLoopLike == true {
      instructions.removeFirst()
    }
  }

  /// Optimizes this program.
  mutating func optimize() {
    instructions.optimizeNested()
    removeInitialLoops()
  }
}

// MARK: - Utilities

extension Instruction {
  fileprivate var isLoopLike: Bool {
    switch self {
    case .loop, .multiply(_, final: 0): true
    default: false
    }
  }
}
