// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes the instructions stored in `program`.
  ///
  /// - Parameter program: The program to execute.
  ///
  /// - Returns: The final state of the interpreter.
  ///
  /// - Throws: ``InterpreterError`` if an issue was encountered during
  ///   execution.
  public consuming func run(_ program: Program) throws -> State {
    for instruction in program.instructions {
      try handleInstruction(instruction)
    }
    return state
  }

  /// Executes an individual ``Instruction``.
  ///
  /// - Parameter instruction: The instruction to execute.
  ///
  /// - Throws: ``InterpreterError`` if an issue was encountered during
  ///   execution.
  mutating func handleInstruction(_ instruction: Instruction) throws {
    switch instruction {
    // MARK: Core

    case let .add(count):
      handleAddInstruction(count)

    case let .move(count):
      handleMoveInstruction(count)

    case let .loop(instructions):
      try handleLoop(instructions)

    case .output:
      handleOutputInstruction()

    case .input:
      try handleInputInstruction()

    // MARK: Non-core

    case let .multiply(multiplications, final):
      handleMultiplyInstruction(multiplications, final: final)
    }
  }
}
