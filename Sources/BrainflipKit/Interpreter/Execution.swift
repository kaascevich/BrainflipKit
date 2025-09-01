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

    case .add(let count): try handleAddInstruction(count)

    case .move(let count): handleMoveInstruction(count)

    case .loop(let instructions): try handleLoop(instructions)

    case .output: handleOutputInstruction()
    case .input: try handleInputInstruction()

    // MARK: Non-core

    case .setTo(let value): handleSetToInstruction(value)

    case .multiply(let factor, let offset):
      try handleMultiplyInstruction(
        multiplyingBy: factor,
        storingAtOffset: offset
      )

    case .scan(let increment): handleScanInstruction(increment)
    }

    self.totalInstructionsExecuted += 1
  }
}
