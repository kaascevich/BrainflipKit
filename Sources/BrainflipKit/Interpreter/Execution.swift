// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
    /// Executes the instructions stored in `program`.
    ///
    /// - Parameter program: The program to execute.
    ///
    /// - Returns: The final state of the interpreter.
    public consuming func run(_ program: Program) -> State {
        for instruction in program.instructions {
            handleInstruction(instruction)
        }
        return state
    }

    /// Executes an individual ``Instruction``.
    ///
    /// - Parameter instruction: The instruction to execute.
    @usableFromInline
    mutating func handleInstruction(_ instruction: Instruction) {
        switch instruction {
            // MARK: Core

            case .add(let count):
                handleAddInstruction(count)

            case .move(let count):
                handleMoveInstruction(count)

            case .loop(let instructions):
                handleLoop(instructions)

            case .output:
                handleOutputInstruction()

            case .input:
                handleInputInstruction()

            // MARK: Non-core

            case .multiply(let multiplications, let final):
                handleMultiplyInstruction(multiplications, final: final)
        }
    }
}
