// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: The final state of the interpreter.
  ///
  /// - Throws: ``InterpreterError`` if an issue was encountered during
  ///   execution.
  public consuming func runReturningFinalState()
    throws(InterpreterError) -> State
  {
    try execute(program)
    return state
  }

  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: The program's output.
  ///
  /// - Throws: ``InterpreterError`` if an issue was encountered during
  ///   execution.
  public consuming func run() throws(InterpreterError) -> Output {
    try runReturningFinalState().outputStream
  }

  /// Executes the provided instructions.
  ///
  /// - Parameter instructions: The instructions to execute.
  ///
  /// - Throws: ``InterpreterError`` if an issue was encountered during
  ///   execution.
  mutating func execute(_ instructions: [Instruction])
    throws(InterpreterError)
  {
    for instruction in instructions {
      try handleInstruction(instruction)
    }
  }

  /// Executes an individual ``Instruction``.
  ///
  /// - Parameter instruction: The instruction to execute.
  ///
  /// - Throws: ``InterpreterError`` if an issue was encountered during
  ///   execution.
  mutating func handleInstruction(_ instruction: Instruction)
    throws(InterpreterError)
  {
    switch instruction {
    // MARK: Core

    case let .add(count): try handleAddInstruction(count)

    case let .move(count): handleMoveInstruction(count)

    case let .loop(instructions): try handleLoop(instructions)

    case .output: handleOutputInstruction()
    case .input: try handleInputInstruction()

    // MARK: Non-core

    case let .setTo(value): handleSetToInstruction(value)

    case let .multiply(factor, offset):
      try handleMultiplyInstruction(
        multiplyingBy: factor,
        storingAtOffset: offset
      )

    case let .scan(increment): handleScanInstruction(increment)
    }

    self.totalInstructionsExecuted += 1
  }
}
