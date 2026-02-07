// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Algorithms

extension [Instruction] {
    // MARK: - Optimizations

    /// Removes adjacent instructions of the same type.
    private mutating func removeAdjacentInstructions() {
        var index = startIndex
        while index < endIndex {
            switch self[index] {
                case .add:
                    var sum: CellValue = 0
                    while index < endIndex, case .add(let value) = self[index] {
                        sum &+= value
                        remove(at: index)
                    }

                    if sum != 0 {
                        insert(.add(sum), at: index)
                    }

                case .move:
                    var sum: CellOffset = 0
                    while index < endIndex, case .move(let offset) = self[index] {
                        sum &+= offset
                        remove(at: index)
                    }

                    if sum != 0 {
                        insert(.move(sum), at: index)
                    }

                default: break
            }

            index += 1
        }
    }

    /// Optimizes multiply instructions.
    private mutating func optimizeMultiplyInstructions() {
        top: for case (let index, .loop(let instructions)) in indexed() {
            var currentOffset: CellOffset = 0
            var multiplications: [CellOffset: CellValue] = [:]

            for instruction in instructions {
                switch instruction {
                    case .add(let value): multiplications[currentOffset, default: 0] &+= value
                    case .move(let offset): currentOffset &+= offset
                    default: continue top
                }
            }

            guard currentOffset == 0, multiplications[0] == -1 else {
                continue top
            }

            multiplications[0] = nil
            self[index] = .multiply(multiplications)
        }

        // MARK: multiply(_, final) add(value) -> multiply(_, final + value)
        for case (
            (let firstIndex, .multiply(let multiplications, let final)),
            (let secondIndex, .add(let value))
        ) in indexed().adjacentPairs().reversed() {
            remove(at: secondIndex)
            self[firstIndex] = .multiply(multiplications, final: final &+ value)
        }

        // MARK: add(_) multiply([:], final) -> multiply([:], final)
        for case (
            (let index, let first),
            (_, .multiply([:], final: _))
        ) in indexed().adjacentPairs().reversed() {
            switch first {
                case .add, .multiply([:], final: _): remove(at: index)
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
        for case ((_, .loop), (let secondIndex, .loop))
            in indexed().adjacentPairs().reversed()
        {
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
