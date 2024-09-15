// Optimizer.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

private import Algorithms
private import CasePaths

extension Program {
  /// Contains optimizer functions for Brainflip programs.
  enum Optimizer {
    // MARK: - Optimizations

    /// Condenses clear loops.
    /// 
    /// This optimization condenses clear loops into a single
    /// `setTo(0)` instruction. If there's an `add` instruction
    /// following the clear loop, the value of that instruction
    /// is used in the `setTo` instruction instead of 0, and the
    /// `add` instruction is removed.
    ///
    /// - Parameter program: The program to optimize.
    private static func optimizeClearLoops(_ program: inout Program) {
      program.replace([.loop([.add(-1)])], with: [.setTo(0)])
      
      let windows = [_](program.enumerated()).windows(ofCount: 2)
      var instructionsToCondense: [ClosedRange<Int>: UInt32] = [:]
      for window in windows {
        // check if the first instruction is a clear loop
        // and the second is an `add` instruction
        guard
          let first = window.first,
          let second = window.last,
          first.element == .setTo(0),
          case .add(let value) = second.element
        else { continue }

        // add these instructions' range and the value of the `add`
        // instruction to the dictionary
        instructionsToCondense[first.offset...second.offset] = UInt32(bitPattern: value)
      }

      // condense instructions from last to first, so as not
      // to invalidate indices before we've used them
      for (range, value) in instructionsToCondense.reversed() {
        // condense the instructions
        program.replaceSubrange(range, with: [.setTo(value)])
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
        // we only need to check the first value, since all others
        // should match it
        let casePath: _? = switch chunk.first {
        case .add:  /Instruction.add
        case .move: /Instruction.move
        default: nil
        }
        
        // make sure we're actually dealing with one of the
        // cases we're interested in optimizing
        guard let casePath else {
          return chunk
        }
        
        let values = chunk.map { casePath.extract(from: $0)! }
        let sum = values.reduce(0, +)
        return [casePath.embed(sum)]
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
        // Swift doesn't have pattern matching for arrays, so we
        // have to do this the hard way.
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
        // Swift doesn't have pattern matching for arrays, so we
        // have to do this the hard way.
        guard
          case let .loop(instructions) = instruction,
          instructions.count == 4
        else { return instruction }
        
        // check if the loop's instructions match what
        // we're looking for
        guard
          case .add(-1)          = instructions[0],
          case .move(let offset) = instructions[1],
          case .add(let factor)  = instructions[2],
          case .move(-offset)    = instructions[3],
          factor >= 0
        else { return instruction }
        
        return .multiply(
          factor: .init(factor),
          offset: Int(offset)
        )
      }
    }
    
    /// Removes loops that will never be executed.
    /// 
    /// In Brainflip, loops will only start (or continue) looping if
    /// the current cell is not zero. This means that, for the instruction
    /// directly after a loop, the current cell will always be 0. If
    /// that instruction happens to also be a loop, that loop will never
    /// be executed. So we remove those here.
    /// 
    /// - Parameter program: The program to optimize.
    private static func removeDeadLoops(_ program: inout Program) {
      let windows = [_](program.enumerated()).windows(ofCount: 2)
      var indicesToRemove: [Int] = []
      for window in windows {
        if case .loop = window.first?.element, case .loop = window.last?.element {
          // there's a loop immediately after another loop, so the second
          // loop will never be executed (because the current cell is
          // always 0 immediately after a loop)
          indicesToRemove.append(window.last!.offset)
        }
      }
      
      // remove indices from last to first, so as not
      // to invalidate indices before we've used them
      for index in indicesToRemove.reversed() {
        program.remove(at: index)
      }
    }
    
    // MARK: - Main Optimizer
    
    /// Optimizes a program, ignoring instructions within loops.
    /// 
    /// - Parameter program: The program to optimize.
    /// 
    /// - Returns: The optimized program.
    static func optimizingWithoutNesting(_ program: Program) -> Program {
      // TODO: This method is _extremely_ sensitive to the order
      // of the optimizations. We should find a way to reliably
      // determine the proper order.

      var program = program
            
      var previousOptimization: Program
      repeat {
        previousOptimization = program
        removeDeadLoops(&program)
        optimizeClearLoops(&program)
        removeAdjacentInstructions(&program)
        removeUselessInstructions(&program)
        optimizeScanLoops(&program)
      } while program != previousOptimization

      optimizeMultiplyLoops(&program)
      
      return program
    }
  }
}
