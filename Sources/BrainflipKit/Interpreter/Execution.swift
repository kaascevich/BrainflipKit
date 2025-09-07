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
  mutating func handleInstruction(_ instruction: Instruction) {
    switch instruction {
    // MARK: Core

    case let .add(count):
      handleAddInstruction(count)

    case let .move(count):
      handleMoveInstruction(count)

    case let .loop(instructions):
      handleLoop(instructions)

    case .output:
      handleOutputInstruction()

    case .input:
      handleInputInstruction()

    // MARK: Non-core

    case let .multiply(multiplications, final):
      handleMultiplyInstruction(multiplications, final: final)
    }
  }
}
