// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

private import Algorithms

/// Contains optimizer functions for Brainflip programs.
enum Optimizer {
  // MARK: - Optimizations

  /// Condenses clear loops.
  ///
  /// This optimization condenses clear loops into a single `setTo(0)`
  /// instruction. If there's an `add` instruction following the clear loop, the
  /// value of that instruction is used in the `setTo` instruction instead of 0,
  /// and the `add` instruction is removed.
  ///
  /// - Parameter program: The program to optimize.
  private static func optimizeClearLoops(_ program: inout Program) {
    // MARK: [-]/[+] -> setTo(0)
    for case let (index, .loop(instructions)) in program.indexed()
    where instructions == [.add(1)] || instructions == [.add(-1)] {
      program[index] = .setTo(0)
    }

    // MARK: setTo(lhs) add(rhs) -> setTo(lhs + rhs)
    // check if the first instruction is a clear loop
    // and the second is an `add` instruction
    for case let (
      (firstIndex, .setTo(lhs)),
      (secondIndex, .add(rhs))
    ) in program.indexed().adjacentPairs().reversed() {
      program[firstIndex] = .setTo(lhs + rhs)
      program.remove(at: secondIndex)
    }

    // MARK: add(_) setTo(rhs) -> setTo(rhs)
    for (
      (index, first),
      (_, second)
    ) in program.indexed().adjacentPairs().reversed()
    where (first.is(\.add) || first.is(\.setTo)) && second.is(\.setTo) {
      program.remove(at: index)
    }
  }

  /// Removes adjacent instructions of the same type.
  ///
  /// - Parameter program: The program to optimize.
  private static func removeAdjacentInstructions(_ program: inout Program) {
    let chunks = program.chunked {
      switch ($0, $1) {
      // we only care about these two instruction types
      case (.add, .add), (.move, .move): true
      default: false
      }
    }

    program = chunks.flatMap { chunk in
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
      return [casePath(sum)]
    }
  }

  /// Removes useless instructions from the program.
  ///
  /// - Parameter program: The program to optimize.
  private static func removeUselessInstructions(_ program: inout Program) {
    program.removeAll { $0 == .add(0) || $0 == .move(0) }
  }

  /// Optimizes scan loops.
  ///
  /// - Parameter program: The program to optimize.
  private static func optimizeScanLoops(_ program: inout Program) {
    for case let (index, .loop(instructions)) in program.indexed()
    where instructions.count == 1 {
      guard case let .move(increment) = instructions[0]
      else { continue }

      program[index] = .scan(increment)
    }
  }

  /// Optimizes multiplication loops.
  ///
  /// - Parameter program: The program to optimize.
  private static func optimizeMultiplyLoops(_ program: inout Program) {
    for case let (index, .loop(instructions)) in program.indexed()
    where instructions.count == 4 {
      // check if the loop's instructions match what we're looking for
      if
        case .add(-1) = instructions[0],
        case let .move(offset) = instructions[1],
        case let .add(factor) = instructions[2],
        case .move(-offset) = instructions[3]
      {
        program[index] = .multiply(factor: factor, offset: offset)
      } else if
        case let .move(offset) = instructions[0],
        case let .add(factor) = instructions[1],
        case .move(-offset) = instructions[2],
        case .add(-1) = instructions[3]
      {
        program[index] = .multiply(factor: factor, offset: offset)
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
  ///
  /// - Parameter program: The program to optimize.
  private static func removeDeadLoops(_ program: inout Program) {
    let pairs = program.indexed().adjacentPairs()
    for case let ((_, .loop), (index, .loop)) in pairs.reversed() {
      // there's a loop immediately after another loop, so the second loop will
      // never be executed (because the current cell is always 0 immediately
      // after a loop)
      program.remove(at: index)
    }
  }

  // MARK: - Main Optimizer

  /// Optimizes a program, ignoring instructions within loops (unless those
  /// loops can be optimized away entirely).
  ///
  /// - Parameter program: The program to optimize.
  ///
  /// - Returns: The optimized program.
  static func optimizingWithoutNesting(_ program: Program) -> Program {
    var program = program

    // loop until no more optimizations are possible

    var previousOptimization: Program

    repeat {
      previousOptimization = program
      removeAdjacentInstructions(&program)
      removeUselessInstructions(&program)
    } while program != previousOptimization

    repeat {
      previousOptimization = program
      removeDeadLoops(&program)
    } while program != previousOptimization

    repeat {
      previousOptimization = program
      optimizeScanLoops(&program)
      optimizeClearLoops(&program)
    } while program != previousOptimization

    optimizeMultiplyLoops(&program)

    return program
  }
}
