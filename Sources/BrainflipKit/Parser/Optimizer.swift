// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

private import Algorithms
import CasePaths

extension Program {
  /// Contains optimizer functions for Brainflip programs.
  enum Optimizer {
    // MARK: - Optimizations

    /// Condenses clear loops.
    ///
    /// This optimization condenses clear loops into a single `setTo(0)`
    /// instruction. If there's an `add` instruction following the clear loop,
    /// the value of that instruction is used in the `setTo` instruction instead
    /// of 0, and the `add` instruction is removed.
    ///
    /// - Parameter program: The program to optimize.
    private static func optimizeClearLoops(_ program: inout Program) {
      // MARK: [-]/[+] -> setTo(0)
      program = program.map { instruction in
        guard
          case let .loop(instructions) = instruction,
          instructions == [.add(1)] || instructions == [.add(-1)]
        else {
          return instruction
        }

        return .setTo(0)
      }

      // MARK: setTo(lhs) add(rhs) -> setTo(lhs + rhs)
      let windows = [_](program.enumerated()).windows(ofCount: 2)
      for window in windows.reversed() {
        let (firstIndex, first) = window.first!
        let (secondIndex, second) = window.last!

        // check if the first instruction is a clear loop
        // and the second is an `add` instruction
        if case let .setTo(lhs) = first, case let .add(rhs) = second {
          program[firstIndex] = .setTo(CellValue(bitPattern: Int32(lhs) + rhs))
          program.remove(at: secondIndex)
        }
      }

      // MARK: add(_) setTo(rhs) -> setTo(rhs)
      for index in program.indices.dropLast().reversed() {
        let first = program[index]
        let next = program[index + 1]
        if (first.is(\.add) || first.is(\.setTo)) && next.is(\.setTo) {
          program.remove(at: index)
        }
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

      program = chunks.flatMap { chunk -> Array.SubSequence in
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
        let values = chunk.map { $0[case: casePath]! }
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
      program = program.map { instruction in
        // Swift doesn't have pattern matching for arrays, so we have to do this
        // the hard way.
        guard
          case let .loop(instructions) = instruction,
          instructions.count == 1,
          case let .move(increment) = instructions[0]
        else { return instruction }

        return .scan(increment)
      }
    }

    /// Optimizes multiplication loops.
    ///
    /// - Parameter program: The program to optimize.
    private static func optimizeMultiplyLoops(_ program: inout Program) {
      program = program.map { instruction in
        // Swift doesn't have pattern matching for arrays, so we have to do this
        // the hard way.
        guard
          case let .loop(instructions) = instruction,
          instructions.count == 4
        else { return instruction }

        // check if the loop's instructions match what we're looking for
        guard
          case .add(-1) = instructions[0],
          case let .move(offset) = instructions[1],
          case let .add(factor) = instructions[2],
          case .move(-offset) = instructions[3],
          factor >= 0
        else { return instruction }

        return .multiply(
          factor: CellValue(factor),
          offset: Int(offset)
        )
      }
    }

    /// Removes loops that will never be executed.
    ///
    /// In Brainflip, loops will only start (or continue) looping if the current
    /// cell is not zero. This means that, for the instruction directly after a
    /// loop, the current cell will always be 0. If that instruction happens to
    /// also be a loop, that loop will never be executed. So we remove those
    /// loops here.
    ///
    /// - Parameter program: The program to optimize.
    private static func removeDeadLoops(_ program: inout Program) {
      let windows = [_](program.enumerated()).windows(ofCount: 2)
      for window in windows.reversed() {
        let (_, first) = window.first!
        let (secondIndex, second) = window.last!
        if first.is(\.loop) || first.is(\.setTo), second.is(\.loop) {
          // there's a loop immediately after another loop, so the second loop
          // will never be executed (because the current cell is always 0
          // immediately after a loop)
          program.remove(at: secondIndex)
        }
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
      // FIXME: This method is _extremely_ sensitive to the order of the
      // optimizations -- if the order isn't correct, all sorts of icky stuff
      // can happen. We should find a way to reliably determine the proper
      // order.

      var program = program

      // loop until no more optimizations are possible
      var previousOptimization: Program
      repeat {
        previousOptimization = program
        removeDeadLoops(&program)
        removeAdjacentInstructions(&program)
        removeUselessInstructions(&program)
        optimizeScanLoops(&program)
      } while program != previousOptimization

      optimizeClearLoops(&program)
      optimizeMultiplyLoops(&program)

      return program
    }
  }
}
