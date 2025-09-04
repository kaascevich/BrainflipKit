// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

internal import Algorithms

extension [Instruction] {
  // MARK: - Optimizations

  /// Optimizes loops.
  private mutating func optimizeLoops() {
    for case (let index, .loop(var instructions)) in indexed() {
      // MARK: Sub-Optimizations
      instructions.optimizeNested()

      self[index] =
        switch instructions.count {
        case 1:
          switch instructions[0] {
          // MARK: Scan Loops
          case let .move(increment):
            .scan(increment)

          // MARK: Clear Loops
          case .add(1), .add(-1):
            .setTo(0)

          default:
            .loop(instructions)
          }

        case 4:
          // MARK: Multiply Loops
          switch (
            instructions[0],
            instructions[1],
            instructions[2],
            instructions[3]
          ) {
          case let (.add(-1), .move(offset), .add(factor), .move(negOffset))
          where offset == -negOffset,
            let (.move(offset), .add(factor), .move(negOffset), .add(-1))
          where offset == -negOffset:
            .multiply(factor: factor, offset: offset)

          default:
            .loop(instructions)
          }

        default:
          .loop(instructions)
        }
    }
  }

  /// Condenses clear loops.
  private mutating func optimizeClearLoops() {
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
      (firstIndex, first),
      (_, .setTo)
    ) in indexed().adjacentPairs().reversed() {
      switch first {
      case .add, .setTo:
        remove(at: firstIndex)

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
      in indexed().adjacentPairs().reversed()
    {
      // there's a loop immediately after another loop, so the second loop
      // will never be executed (because the current cell is always 0
      // immediately after a loop)
      remove(at: secondIndex)
    }
  }

  /// Optimizes this program.
  fileprivate mutating func optimizeNested() {
    removeDeadLoops()
    optimizeLoops()
    optimizeClearLoops()
  }
}

// MARK: - Root Optimizations

extension Program {
  /// Removes a loop from the start of the program.
  ///
  /// Doesn't bother removing more than 1 loop, since the others should have
  /// already been optimized away by this point.
  private mutating func removeInitialLoops() {
    switch instructions.first {
    case .loop, .multiply, .scan, .setTo(0): instructions.removeFirst()
    default: break
    }
  }

  /// Optimizes this program.
  mutating func optimize() {
    instructions.optimizeNested()
    removeInitialLoops()
  }
}
